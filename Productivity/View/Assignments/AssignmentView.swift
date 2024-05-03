//
//  AssignmentView.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import SwiftUI

struct AssignmentView: View {

    @Binding var assignment: Assignment
    
    init(assignment: Binding<Assignment>) {
        self._assignment = assignment
    }
    
    var body: some View {
        NavigationView(title: "Assignment") {
            HStack{
                Spacer()
                VStack{
                    HStack{
                        Text(assignment.name)
                            .font(.largeTitle)
                        NavigationLink {
                            EditAssignmentView(assignmentBinding: $assignment, assignment: assignment)
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .imageScale(.large)

                        }
                    }.padding(20)
                    Text("Due: \(assignment.dueDate)")
                        .font(.caption)
                    Text(assignment.description)
                    Spacer()
                }
                Spacer()
            }
            
        }
    }
}
