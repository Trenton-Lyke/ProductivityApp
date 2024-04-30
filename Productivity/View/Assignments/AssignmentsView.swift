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
                Text(assignment.name)
                
                if assignment.done {
                    Image(systemName: "checkmark.seal.fill")
                        .imageScale(.large)
                        .foregroundStyle(.blue)
                } else {
                    Spacer()
                    HStack(spacing: 20){
                        Button{
                            
                        } label: {
                            Image(systemName: "checkmark.square.fill")
                                .imageScale(.large)
                                .foregroundStyle(.green)
                        }
                        Button{
                            
                        } label: {
                            Image(systemName: "x.square.fill")
                                .imageScale(.large)
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AssignmentsView()
}
