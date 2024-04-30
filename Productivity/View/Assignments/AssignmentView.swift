//
//  AssignmentView.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import SwiftUI

struct AssignmentView: View {
    var assignment: Assignment
    
    var body: some View {
        NavigationView(title: "Assignment") {
            HStack{
                Spacer()
                VStack{
                    HStack{
                        Text(assignment.name)
                            .font(.largeTitle)
                        NavigationLink {
                            EditAssignmentView(assignment: assignment)
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .imageScale(.large)

                        }
                    }.padding(20)
                    Text(assignment.description)
                    Spacer()
                }
                Spacer()
            }
            
        }
    }
}

#Preview {
    AssignmentView(assignment: Assignment.dummyAssignment)
}
