//
//  ContentView.swift
//  Todoey
//
//  Created by Alex Yang on 4/14/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = TodoListViewModel()
    @State private var newTodoTitle: String = ""

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Title", text: $newTodoTitle)
                        .onSubmit {
                            Task {
                                await vm.createTodo(title: newTodoTitle)
                                newTodoTitle = ""
                            }
                        }
                }

                switch vm.state {
                case .idle: Text("Make a request")
                case .loading: Text("Loading...")
                case .success(let todos): todoListView(todos: todos)
                case .error(let message): Text("Error: \(message)")
                }
            }
            .navigationTitle("Todoey Twoey")
            .refreshable {
                await vm.fetchTodos()
            }
        }
        .task {
            await vm.fetchTodos()
        }
    }

    @ViewBuilder
    private func todoListView(todos: [Todo]) -> some View {
        ForEach(todos) { todo in
            Button {
                Task {
                    await vm.toggleCompletion(for: todo)
                }
            } label: {
                Label(todo.title, systemImage: todo.isCompleted ? "circle.fill" : "circle")
            }
            .swipeActions {
                Button(role: .destructive) {
                    Task {
                        await vm.delete(todo: todo)
                    }
                } label: {
                    Image(systemName: "trash")
                }
                .tint(.red)
            }
        }
    }
}

#Preview {
    ContentView()
}
