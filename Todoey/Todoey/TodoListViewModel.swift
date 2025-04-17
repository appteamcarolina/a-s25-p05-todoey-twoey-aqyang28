//
//  TodoListViewModel.swift
//  Todoey
//
//  Created by Alex Yang on 4/14/25.
//

import Foundation

enum TodoListLoadingState {
    case success(todos: [Todo])
    case error(error: String)
    case loading
    case idle
}

@MainActor
class TodoListViewModel: ObservableObject {
    @Published var state: TodoListLoadingState = .idle

    func fetchTodos() async {
        do {
            let todos = try await TodoListService.getTodos()
            self.state = .success(todos: todos)
        } catch {
            self.state = .error(error: error.localizedDescription)
        }
    }

    func createTodo(title: String) async {
        do {
            let _ = try await TodoListService.create(newTodo: NewTodo(title: title))
            self.state = try .success(todos: await TodoListService.getTodos())
        } catch {
            self.state = .error(error: error.localizedDescription)
        }
    }

    func delete(todo: Todo) async {
        do {
            try await TodoListService.delete(todo: todo)
            self.state = try .success(todos: await TodoListService.getTodos())
        } catch {
            self.state = .error(error: error.localizedDescription)
        }
    }

    func toggleCompletion(for todo: Todo) async {
        do {
            try await TodoListService.updateCompletion(for: todo, isCompleted: todo.isCompleted ? false : true)
            self.state = try .success(todos: await TodoListService.getTodos())
        } catch {
            self.state = .error(error: error.localizedDescription)
        }
    }
}
