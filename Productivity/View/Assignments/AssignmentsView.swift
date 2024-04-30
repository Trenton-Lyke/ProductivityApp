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
                ForEach(UserDataManager.shared.getCourses(), id: \.id) { course in
                    Section {
                        DisclosureGroup(course.name) {
                            ForEach(course.assignments, id: \.id) { assignment in
                                AssignmentRow(assignment: assignment)
                            }
                        }
                    }
                }

                
                
                if userManager.isLoggedIn() {
                    NavigationLink {
                        CreateAssignmentView()
                    } label: {
                        Label("Add new assignment", systemImage: "plus")
                            .foregroundStyle(.blue)
                    }
                } else {
                    NavigationLink {
                        AccountView(isTemporaryAuth: true)
                    } label: {
                        Text("Login to view assignments")
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
    }
}

struct AssignmentRow: View {
    let assignment: Assignment
    

    var body: some View {
        
            NavigationLink {
                AssignmentView(assignment: assignment)
            } label: {
                HStack {
                if assignment.done {
                    Image(systemName: "circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(.pink)
                        .onTapGesture { print("One") }
                } else {
                    Image(systemName: "circle")
                        .imageScale(.large)
                        .foregroundStyle(.pink)
                        .onTapGesture { print("Two") }
                }
                Text(assignment.name)
                Spacer()
                
                    Image(systemName: "trash")
                        .imageScale(.large)
                        .foregroundStyle(.red)
                        .onTapGesture { print("Two") }

            }
        }
    }
}

#Preview {
    AssignmentsView()
}
