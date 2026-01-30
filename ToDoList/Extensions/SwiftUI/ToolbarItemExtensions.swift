//
//  ToolbarItemExtensions.swift
//  ToDoList
//
//  Created by Anton Kaizer on 29.01.26.
//

import SwiftUI

extension ToolbarContent {
    func liquidGlassNoBackground() -> some ToolbarContent {
        if #available(iOS 26, *) {
            return self.sharedBackgroundVisibility(.hidden)
        }
        return self
    }
}
