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
    
    
    func isLoggedIn() -> Bool {
        if let _ = user, let session = session {
            return session.sessionExpiration > Date()
        }
        
        return false
    }
    
    func addAssignment(name: String, description: String, courseId: Int, dueDate: Date, onsuccess: @escaping (Assignment) -> Void, onfailure: @escaping () -> Void) {
        if let currentUser = user {
            var maxId = 0
            for course in currentUser.courses {
                for assignment in course.assignments {
                    maxId = max(maxId, assignment.id)
                }
            }
            let newAssignment = Assignment(id: maxId + 1, name: name, description: description, dueDate: dueDate, done: false, courseId: courseId)
            var courses: [Course] = []
            for course in currentUser.courses {
                if courseId == course.id {
                    let newCourse = Course(id: course.id, name: course.name, code: course.code, description: course.description, assignments: course.assignments + [newAssignment])
                    courses.append(newCourse)
                } else {
                    courses.append(course)
                }
            }
            user = User(id: currentUser.id, name: currentUser.name, courses: courses)
            onsuccess(newAssignment)
        } else {
            onfailure()
        }
    }
    
    func updateAssignment(assignmentId: Int, name: String, description: String, courseId: Int, dueDate: Date, done: Bool, onsuccess: @escaping (Assignment) -> Void, onfailure: @escaping () -> Void) {
        if let currentUser = user {
            let newAssignment = Assignment(id: assignmentId, name: name, description: description, dueDate: dueDate, done: done, courseId: courseId)
            var courses: [Course] = []
            for course in currentUser.courses {
                var assignments: [Assignment] = []
                for assignment in course.assignments {
                    if assignment.id != assignmentId {
                        assignments.append(assignment)
                    } else if courseId == course.id {
                        assignments.append(newAssignment)
                    }
                }
                let newCourse = Course(id: course.id, name: course.name, code: course.code, description: course.description, assignments: assignments)
                courses.append(newCourse)
            }
            for i in 0..<courses.count {
                let course = courses[i]
                if courseId == course.id && !course.assignments.contains(newAssignment){
                    courses[i] = Course(id: course.id, name: course.name, code: course.code, description: course.description, assignments: course.assignments + [newAssignment])
                }
                
            }
            user = User(id: currentUser.id, name: currentUser.name, courses: courses)
            onsuccess(newAssignment)
        } else {
            onfailure()
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
        if let currentUser = user {
            var maxId = 0
            for course in currentUser.courses {
                maxId = max(maxId, course.id)
            }
            let newCourse = Course(id: maxId + 1, name: name, code: code, description: description, assignments: [])
            let courses: [Course] = currentUser.courses + [newCourse]

            user = User(id: currentUser.id, name: currentUser.name, courses: courses)
            onsuccess(newCourse)
        } else {
            onfailure()
        }
    }
    
    func updateCourse(courseId: Int, name: String, code: String, description: String, assignments: [Assignment], onsuccess: @escaping (Course) -> Void, onfailure: @escaping () -> Void) {
        if let currentUser = user {
            let newCourse = Course(id: courseId, name: name, code: code, description: description, assignments: assignments)
            var courses: [Course] = []
            for course in currentUser.courses {
                if courseId != course.id {
                    courses.append(course)
                } else {
                    courses.append(newCourse)
                }
            }

            user = User(id: currentUser.id, name: currentUser.name, courses: courses)
            onsuccess(newCourse)
        } else {
            onfailure()
        }
    }
    
    func deleteCourse(courseId: Int, onsuccess: @escaping (Course) -> Void, onfailure: @escaping () -> Void) {
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
