//
//  Todo.swift
//  Todoey
//
//  Created by Alex Yang on 4/14/25.
//

import Foundation

struct NewTodo: Codable {
    let title: String
}

struct Todo: Identifiable, Codable {
    let id: UUID
    let title: String
    var isCompleted: Bool
}
