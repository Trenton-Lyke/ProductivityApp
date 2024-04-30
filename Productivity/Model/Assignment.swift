//
//  Task.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/27/24.
//

import Foundation

struct Assignment: Codable, Hashable {
    let id: Int
    let name: String
    let description: String
    let dueDate: Date
    let done: Bool
    let courseId: Int
}
