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

    private init() { 
        
    }
    
    func getAssignmentCounts() -> (Int, Int) {
        var assignmentsCount = 0
        var completedAssignmentsCount = 0
        guard let currentUser = user else {
            return (assignmentsCount, completedAssignmentsCount)
        }
        for course in currentUser.courses {
            for assignment in course.assignments {
                assignmentsCount += 1
                
                if assignment.done {
                    completedAssignmentsCount += 1
                }
            }
        }
        return (assignmentsCount, completedAssignmentsCount)
    }

    
    func login(username: String, password: String, onsuccess: (User) -> Void, onfailure: () -> Void) {
        if username == "A" {
            user = User.dummyUser
            
            if let currentUser = user {
                onsuccess(currentUser)
            }
        } else {
            onfailure()
        }
    }
    
    func logout() {
        user = nil
    }
    
    
    func createAccount(firstName: String, lastName: String, username: String, password: String, onsuccess: (User) -> Void, onfailure: () -> Void) {
        if username == "A" {
            user = User(id: 1, name: "\(firstName) \(lastName)", courses: Course.dummyCourses)
            
            if let currentUser = user {
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
    
    func deleteAssignment(assignmentId: Int, onsuccess: (Assignment) -> Void, onfailure: () -> Void) {
        if let currentUser = user {
            var removedAssignment = Assignment.dummyAssignment
            var courses: [Course] = []
            for course in currentUser.courses {
                var assignments: [Assignment] = []
                for assignment in course.assignments {
                    if assignment.id != assignmentId {
                        assignments.append(assignment)
                    } else {
                        removedAssignment = assignment
                    }
                }
                let newCourse = Course(id: course.id, name: course.name, description: course.description, assignments: assignments)
                courses.append(newCourse)
            }
            user = User(id: currentUser.id, name: currentUser.name, courses: courses)
            onsuccess(removedAssignment)
        }
        
        onfailure()
    }
    
    func createCourse(name: String, description: String, onsuccess: (Course) -> Void, onfailure: () -> Void) {
        if name == "A" {
            if let currentUser = user {
                var newCourse = Course(id: currentUser.courses.count, name: name, description: description, assignments: [])
                var courses: [Course] = currentUser.courses + [newCourse]

                user = User(id: currentUser.id, name: currentUser.name, courses: courses)
                onsuccess(newCourse)
            }
            onfailure()
            
        } else {
            onfailure()
        }
    }
    
    func updateCourse(courseId: Int, name: String, description: String, onsuccess: (Course) -> Void, onfailure: () -> Void) {
        if name == "A" {
            onsuccess(Course.dummyCourse1)
        } else {
            onfailure()
        }
    }
    
    func deleteCourse(courseId: Int, onsuccess: (Course) -> Void, onfailure: () -> Void) {
        if let currentUser = user {
            var removedCourse = Course.dummyCourse1
            var courses: [Course] = []
            for course in currentUser.courses {
                if course.id != courseId {
                    courses.append(course)
                } else {
                    removedCourse = course
                }
            }
            user = User(id: currentUser.id, name: currentUser.name, courses: courses)
            onsuccess(removedCourse)
        }
        onfailure()
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
}
