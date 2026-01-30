//
//  ToDoServiceImpl.swift
//  ToDoList
//
//  Created by Anton Kaizer on 28.01.26.
//

import Foundation

struct ToDoItemRemote: nonisolated Codable {
    let title: String
    let completed: Bool
    enum CodingKeys: String, CodingKey {
        case title = "todo"
        case completed
    }
    
    var toToDoItem: ToDoItem {
        ToDoItem(id: "",
                 title: self.title,
                 description: nil,
                 completed: self.completed,
                 date: Date())
    }
}

struct ToDoItemsResponse: nonisolated Codable {
    let todos: [ToDoItemRemote]
}

final class ToDoServiceImpl: ToDoService {
    private let url = URL(string: "https://dummyjson.com/todos")!
    
    func loadToDoItem(_ completion: @escaping ([ToDoItem], (any Error)?) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion([], error)
                return
            }
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data else {
                completion([], NSError(domain: "ToDoService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Bad service response"]))
                return
            }
            guard let parsedResponse = try? JSONDecoder().decode(ToDoItemsResponse.self, from: data) else {
                completion([], NSError(domain: "ToDoService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Bad JSON"]))
                return
            }
            completion(parsedResponse.todos.map(\.toToDoItem), nil)
        }
        task.resume()
    }
}
