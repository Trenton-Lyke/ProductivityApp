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
    @Published private var session: SessionData?
    @Published private var position: Int?


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

    func getPosition() -> String {
        if let position = position {
            return "\(position)"
        } else {
            return "Unknown"
        }
    }
    
    func login(username: String, password: String, onsuccess: @escaping (UserSessionData) -> Void, onfailure: @escaping () -> Void) {
        NetworkManager.shared.login(name: username, password: password) { [weak self] userSession in
            if let userSession = userSession, let self = self{
                self.user = userSession.user
                self.session = userSession.session
                self.position = userSession.position
                onsuccess(userSession)
            } else {
                onfailure()
            }
        }
    }
    
    func logout(onsuccess: @escaping () -> Void, onfailure: @escaping () -> Void) {
        NetworkManager.shared.logout(sessionToken: session?.sessionToken ?? "") { [weak self] success in
            guard let self = self else {
                onfailure()
                return
            }
            self.user = nil
            self.session = nil
            self.position = nil
            onsuccess()
        }
    }
    
    
    func createAccount(username: String, password: String, onsuccess: @escaping (UserSessionData) -> Void, onfailure: @escaping () -> Void) {
        NetworkManager.shared.createUser(name: username, password: password) { [weak self] user in
            if let _ = user, let self = self{
                login(username: username, password: password, onsuccess: onsuccess, onfailure: onfailure)
            } else {
                onfailure()
            }
        }
    }
    
    func updateUserData(callback: @escaping () -> Void) {
        if !isLoggedIn() {
            user = nil
            session = nil
            position = nil
            return
        }
        
        guard let currentSession = session else { return }
        NetworkManager.shared.updateUser(sessionToken: currentSession.sessionToken) { [weak self] updatedUser in
            guard let self = self else { return }
            if let updatedUser = updatedUser {
                self.user = updatedUser.user
                self.session = updatedUser.session
                self.position = updatedUser.position
            } else {
                self.user = nil
                self.session = nil
                self.position = nil
            }
            callback()
        }
    }
    
    
    func isLoggedIn() -> Bool {
        if let _ = user, let session = session {
            return session.sessionExpiration > Date()
        }
        
        return false
    }
    
    func addAssignment(name: String, description: String, courseId: Int, dueDate: Date, onsuccess: @escaping (Assignment) -> Void, onfailure: @escaping () -> Void) {
        if !isLoggedIn() {
            onfailure()
            return
        }
        guard let currentSession = session else {
            onfailure()
            return
        }
        NetworkManager.shared.createAssignment(sessionToken: currentSession.sessionToken, courseId: courseId, name: name, description: description, dueDate: dueDate, done: false) { [weak self] assignment in
            guard let self = self else {
                onfailure()
                return
            }
            if let assignment = assignment {
                updateUserData(callback: {onsuccess(assignment)})
            } else {
                onfailure()
            }
        }
    }
    
    func updateAssignment(assignmentId: Int, name: String, description: String, courseId: Int, dueDate: Date, done: Bool, onsuccess: @escaping (Assignment) -> Void, onfailure: @escaping () -> Void) {
        if !isLoggedIn() {
            onfailure()
            return
        }
        guard let currentSession = session else {
            onfailure()
            return
        }
        NetworkManager.shared.updateAssignment(sessionToken: currentSession.sessionToken, courseId: courseId, assignmentId: assignmentId, name: name, description: description, dueDate: dueDate, done: done) { [weak self] assignment in
            guard let self = self else {
                onfailure()
                return
            }
            if let assignment = assignment {
                updateUserData(callback: {onsuccess(assignment)})
            } else {
                onfailure()
            }
        }
    }
    
    func deleteAssignment(assignmentId: Int, onsuccess: @escaping (Assignment) -> Void, onfailure: @escaping () -> Void) {
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
                let newCourse = Course(id: course.id, name: course.name, code: course.code, description: course.description, assignments: assignments)
                courses.append(newCourse)
            }
            user = User(id: currentUser.id, name: currentUser.name, courses: courses)
            onsuccess(removedAssignment)
        }
        
        onfailure()
    }
    
    func createCourse(name: String, code: String, description: String, onsuccess: @escaping (Course) -> Void, onfailure: @escaping () -> Void) {
        if !isLoggedIn() {
            onfailure()
            return
        }
        guard let currentSession = session else {
            onfailure()
            return
        }
        NetworkManager.shared.createCourse(sessionToken: currentSession.sessionToken, name: name, code: code, description: description) { [weak self] course in
            guard let self = self else {
                onfailure()
                return
            }
            if let course = course {
                updateUserData(callback: {onsuccess(course)})
            } else {
                onfailure()
            }
        }
    }
    
    func updateCourse(courseId: Int, name: String, code: String, description: String, onsuccess: @escaping (Course) -> Void, onfailure: @escaping () -> Void) {
        if !isLoggedIn() {
            onfailure()
            return
        }
        guard let currentSession = session else {
            onfailure()
            return
        }
        NetworkManager.shared.updateCourse(sessionToken: currentSession.sessionToken, courseId: courseId, name: name, code: code, description: description) { [weak self] updatedCourse in
            guard let self = self else {
                onfailure()
                return
            }
            if let updatedCourse = updatedCourse {
                updateUserData(callback: {onsuccess(updatedCourse)})
            } else {
                onfailure()
            }
        }
    }
    
    func deleteCourse(courseId: Int, onsuccess: @escaping (Course) -> Void, onfailure: @escaping () -> Void) {
        if !isLoggedIn() {
            onfailure()
            return
        }
        guard let currentSession = session else {
            onfailure()
            return
        }
        NetworkManager.shared.deleteCourse(sessionToken: currentSession.sessionToken, courseId: courseId) { [weak self] removedCourse in
            guard let self = self else {
                onfailure()
                return
            }
            if let removedCourse = removedCourse {
                updateUserData(callback: {onsuccess(removedCourse)})
            } else {
                onfailure()
            }
        }
    }
    
    func getCourse(id: Int) -> Course {
        if let currentUser = user {
            for course in currentUser.courses {
                if id == course.id {
                    return course
                }
            }
        }
        return Course.dummyCourse1
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
