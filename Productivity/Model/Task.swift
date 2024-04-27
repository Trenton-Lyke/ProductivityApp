//
//  Task.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/27/24.
//

import Foundation

struct Task: Codable, Hashable {
    let id: Int
    let name: String
    let description: String
    let dueDate: Date
    let done: Bool
    let isSubtask: Bool
    let parentTaskId: Int
}

struct CreateTaskParameters {
    let name: String
    let description: String
    let dueDate: Date
    let done: Bool
    let isSubtask: Bool
    let parentTaskId: Int
}
