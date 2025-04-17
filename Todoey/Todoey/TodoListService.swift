//
//  TodoListService.swift
//  Todoey
//
//  Created by Alex Yang on 4/14/25.
//

import Foundation

enum TodoListService {
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
        
//    static let baseUrl = "https://learning.appteamcarolina.com/todos"
    static let baseUrl = "https://learning.ryderklein.com/todos"
    
    static let session = URLSession.shared
    
    static func getTodos() async throws -> [Todo] {
        // TODO: Implement. See above for request code
        let components = URLComponents(string: baseUrl)
        guard let url = components?.url else { fatalError("Invalid URL") }
        
        let (data, _) = try await session.data(from: url)
        let todos = try decoder.decode([Todo].self, from: data)
        
        return todos
    }
    
    static func create(newTodo: NewTodo) async throws -> Todo {
        guard let url = URL(string: baseUrl) else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoded: Data = try encoder.encode(newTodo)
        request.httpBody = encoded
        
        let (data, _) = try await session.data(for: request)
        let todo = try decoder.decode(Todo.self, from: data)
        
        return todo
    }
    
    static func delete(todo: Todo) async throws {
        guard let url = URL(string: baseUrl + "/\(todo.id)") else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200 ... 299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
    
    static func updateCompletion(for todo: Todo, isCompleted: Bool) async throws {
        var components = URLComponents(string: baseUrl + "/\(todo.id)/updateCompleted")
        components?.queryItems = [URLQueryItem(name: "isCompleted", value: "\(isCompleted)")]
        
        guard let url = components?.url else { fatalError("Invalid URL") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200 ... 299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
