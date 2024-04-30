//
//  UserManager.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import Foundation

class UserDataManager : ObservableObject {
    
    /// Shared singleton instance
    static let shared = UserDataManager()
    
    @Published private var user: User?
    private var assignmentsCount: Int = 0
    private var completedAssignmentsCount: Int = 0

    private init() { 
        
    }
    
    private func updateAssignmentsCounts() {
        assignmentsCount = 0
        completedAssignmentsCount = 0
        guard let currentUser = user else {
            return
        }
        for course in currentUser.courses {
            for assignment in course.assignments {
                assignmentsCount += 1
                
                if assignment.done {
                    completedAssignmentsCount += 1
                }
            }
        }
    }

    
    func login(username: String, password: String, onsuccess: (User) -> Void, onfailure: () -> Void) {
        if username == "A" {
            user = User.dummyUser
            
            if let currentUser = user {
                updateAssignmentsCounts()
                onsuccess(currentUser)
            }
        } else {
            onfailure()
        }
    }
    
    func logout() {
        user = nil
        updateAssignmentsCounts()
    }
    
    
    func createAccount(firstName: String, lastName: String, username: String, password: String, onsuccess: (User) -> Void, onfailure: () -> Void) {
        if username == "A" {
            user = User(id: 1, name: "\(firstName) \(lastName)", courses: Course.dummyCourses)
            
            if let currentUser = user {
                updateAssignmentsCounts()
                onsuccess(currentUser)
            }
        } else {
            onfailure()
        }
    }
    
    func isLoggedIn() -> Bool {
        if let _ = user {
            return true
        }
        
        return false
    }
    
    func addAssignment(name: String, description: String, courseId: Int, dueDate: Date, onsuccess: (Assignment) -> Void, onfailure: () -> Void) {
        if name == "A" {
            onsuccess(Assignment.dummyAssignment)
        } else {
            onfailure()
        }
    }
    
    func updateAssignment(assignmentId: Int, name: String, description: String, courseId: Int, dueDate: Date, onsuccess: (Assignment) -> Void, onfailure: () -> Void) {
        if name == "A" {
            onsuccess(Assignment.dummyAssignment)
        } else {
            onfailure()
        }
    }
    
    func createCourse(name: String, description: String, onsuccess: (Course) -> Void, onfailure: () -> Void) {
        if name == "A" {
            onsuccess(Course.dummyCourse1)
        } else {
            onfailure()
        }
    }
    
    func getUser() -> User? {
        return user
    }
    
    func getName() -> String {
        guard let currentUser = user else {
            return ""
        }
        
        return currentUser.name
    }
    
    func getCourses() -> [Course] {
        guard let currentUser = user else {
            return []
        }
        
        return currentUser.courses
    }
    
    func getAssignmentCount() -> Int {
        return assignmentsCount
    }
    
    func getCompletedAssignmentCount() -> Int {
        return completedAssignmentsCount
    }
}
