//
//  Course+Extension.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import Foundation

extension Course {
    static let dummyCourse1 = Course(id: 1, name: "Course 1", description: "The first course you must take", assignments: Assignment.dummyAssignmentListC1)
    
    static let dummyCourse2 = Course(id: 2, name: "Course 2", description: "The second course you must take", assignments: Assignment.dummyAssignmentListC2)
    
    static let dummyCourse3 = Course(id: 3, name: "Course 3", description: "The third course you must take", assignments: Assignment.dummyAssignmentListC3)
    
    static let dummyCourse4 = Course(id: 4, name: "Course 4", description: "The fourth course you must take", assignments: Assignment.dummyAssignmentListC4)
    
    static let dummyCourses = [
        dummyCourse1,
        dummyCourse2,
        dummyCourse3,
        dummyCourse4
    ]
}
