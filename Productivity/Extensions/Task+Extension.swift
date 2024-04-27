//
//  Task+Extension.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/27/24.
//

import Foundation

extension Task {
    static let dummyParentTask = Task(id: 1, name: "Do HW", description: "Complete HW", dueDate: Date(), done: false, isSubtask: false, parentTaskId: -1)
    
    static let dummySubTask = Task(id: 2, name: "Do Algo", description: "Complete Algo PSET", dueDate: Date(), done: false, isSubtask: true, parentTaskId: 1)
}
