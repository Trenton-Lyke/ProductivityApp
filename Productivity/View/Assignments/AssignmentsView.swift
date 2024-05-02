//
//  AssignmentsView.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import SwiftUI

struct AssignmentsView: View {
    @StateObject private var userManager = UserDataManager.shared
    
    var body: some View {
        NavigationView(title: "Assignments") {
            List {
                ForEach(userManager.getCourses(), id: \.id) { course in
                    Section {
                        DisclosureGroup(course.name) {
                            ForEach(course.assignments, id: \.self) { assignment in
                                AssignmentRow(assignment: assignment)
                            }
                            NavigationLink {
                                CreateAssignmentView(courseId: course.id)
                            } label: {
                                Label("Add new assignment", systemImage: "plus")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                }

                
                
                if !userManager.isLoggedIn() {
                    NavigationLink {
                        AccountView(isTemporaryAuth: true)
                    } label: {
                        Text("Login to view assignments")
                            .foregroundStyle(.blue)
                    }
                } else if userManager.getCourses().count == 0 {
                    NavigationLink {
                        CreateCourseView(isTemporaryWindow: true)
                    } label: {
                        Text("Create a course to add and view assignments")
                            .foregroundStyle(.blue)
                    }
                    
                }
            }
        }
    }
}

struct AssignmentRow: View {
    @State private var assignment: Assignment
    
    
    init(assignment: Assignment) {
        self._assignment = State(initialValue: assignment)
    }

    var body: some View {
        
            NavigationLink {
                AssignmentView(assignment: $assignment)
            } label: {
                HStack {
                
                    Image(systemName: assignment.done ? "circle.fill" : "circle")
                    .imageScale(.large)
                    .foregroundStyle(.pink)
                    .onTapGesture {
                        UserDataManager.shared.updateAssignment(assignmentId: assignment.id, name: assignment.name, description: assignment.description, courseId: assignment.courseId, dueDate: assignment.dueDate, done: !assignment.done) { assignment in

                        } onfailure: {
                            
                        }

                    }

                Text(assignment.name)
                Spacer()
                
                Image(systemName: "trash")
                    .imageScale(.large)
                    .foregroundStyle(.red)
                    .onTapGesture {
                        UserDataManager.shared.deleteAssignment(assignmentId: assignment.id, onsuccess: {_ in }, onfailure: {})
                    }

            }
        }
    }
}

#Preview {
    AssignmentsView()
}
