//
//  ToDoEditView.swift
//  ToDoList
//
//  Created by Anton Kaizer on 29.01.26.
//

import SwiftUI

struct ToDoEditView: View {
    enum FocusedField {
        case title, description
    }
    @StateObject var viewState: ToDoEditViewState
    
    @ScaledMetric(relativeTo: .largeTitle) var titleFontSize: CGFloat = 34
    @ScaledMetric(relativeTo: .body) var dateFontSize: CGFloat = 12
    @ScaledMetric(relativeTo: .body) var bodyFontSize: CGFloat = 16
    
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                TextField("Заголовок", text: $viewState.title, axis: .vertical)
                    .focused($focusedField, equals: .title)
                    .font(.system(size: titleFontSize))
                    .fontWeight(.bold)
                    .onTapGesture {
                        focusedField = .title
                    }
                
                Text(viewState.date.formatted(date: .numeric, time: .omitted))
                    .font(.system(size: dateFontSize))
                    .opacity(0.5)
                    .fixedSize()
                TextField("Описание", text: $viewState.desc, axis: .vertical)
                    .focused($focusedField, equals: .description)
                    .font(.system(size: bodyFontSize))
                    
            }
            .padding()
        }
        .onTapGesture {
            focusedField = .description
        }
        .task {
            if self.viewState.title.count > 0 {
                focusedField = .description
            } else {
                focusedField = .title
            }
        }
        .onWillDisappear {
            viewState.onDisappear()
        }
    }
}

#if DEBUG

extension ToDoEditView {
    static func mockState() -> ToDoEditViewState {
        UITextView.appearance().textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return ToDoEditViewState(title: "Новый Новый Новый Новый", desc: "Asdasd asd", date: Date())
    }
}

#endif

#Preview {
    NavigationStack{
        ToDoEditView(viewState: ToDoEditView.mockState())
            .navigationTitle("Редактирвоание")
    }
}
