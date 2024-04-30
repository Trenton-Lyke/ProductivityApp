//
//  Assignment+Extension.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import Foundation

extension Assignment {
    static let dummyAssignment = Assignment(id: 1, name: "Homework 1", description: "Do homework 1 as soon as possible", dueDate: Date(), done: false, courseId: 1)
    
    static let dummyAssignmentListC1 = [
        Assignment(id: 1, name: "Homework 1", description: "Do homework 1 as soon as possible", dueDate: Date(), done: true, courseId: 1),
        Assignment(id: 2, name: "Homework 2", description: "Do homework 2 as soon as possible", dueDate: Date(), done: false, courseId: 1),
        Assignment(id: 3, name: "Homework 3", description: "Do homework 3 as soon as possible", dueDate: Date(), done: true, courseId: 1),
        Assignment(id: 4, name: "Homework 4", description: "Do homework 4 as soon as possible", dueDate: Date(), done: false, courseId: 1)
    ]
    
    static let dummyAssignmentListC2 = [
        Assignment(id: 5, name: "Homework 1", description: "Do homework 1 as soon as possible", dueDate: Date(), done: true, courseId: 2),
        Assignment(id: 6, name: "Homework 2", description: "Do homework 2 as soon as possible", dueDate: Date(), done: false, courseId: 2),
        Assignment(id: 7, name: "Homework 3", description: "Do homework 3 as soon as possible", dueDate: Date(), done: true, courseId: 2),
        Assignment(id: 8, name: "Homework 4", description: "Do homework 4 as soon as possible", dueDate: Date(), done: false, courseId: 2)
    ]
    
    static let dummyAssignmentListC3 = [
        Assignment(id: 9, name: "Homework 1", description: "Do homework 1 as soon as possible", dueDate: Date(), done: true, courseId: 3),
        Assignment(id: 10, name: "Homework 2", description: "Do homework 2 as soon as possible", dueDate: Date(), done: false, courseId: 3),
        Assignment(id: 11, name: "Homework 3", description: "Do homework 3 as soon as possible", dueDate: Date(), done: true, courseId: 3),
        Assignment(id: 12, name: "Homework 4", description: "Do homework 4 as soon as possible", dueDate: Date(), done: false, courseId: 3)
    ]
    
    static let dummyAssignmentListC4 = [
        Assignment(id: 13, name: "Homework 1", description: "Do homework 1 as soon as possible", dueDate: Date(), done: true, courseId: 4),
        Assignment(id: 14, name: "Homework 2", description: "Do homework 2 as soon as possible", dueDate: Date(), done: false, courseId: 4),
        Assignment(id: 15, name: "Homework 3", description: "Do homework 3 as soon as possible", dueDate: Date(), done: true, courseId: 4),
        Assignment(id: 16, name: "Homework 4", description: "Do homework 4 as soon as possible", dueDate: Date(), done: false, courseId: 4)
    ]
}
