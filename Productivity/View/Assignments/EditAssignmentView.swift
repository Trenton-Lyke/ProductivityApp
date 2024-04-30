//
//  EditAssignmentView.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import SwiftUI
import AlertToast

struct EditAssignmentView: View {
    var assignment: Assignment
    
    @State private var name: String
    @State private var description: String
    @State private var dueDate: Date
    @State private var selectedCourseId: Int
    @State private var showSuccess = false
    @State private var showFailure = false
    
    init(assignment: Assignment) {
        self.assignment = assignment
        name = self.assignment.name
        description = self.assignment.description
        dueDate = self.assignment.dueDate
        selectedCourseId = self.assignment.courseId
    }
    
    var body: some View {
        NavigationView(title: "Edit Assignment") {
            VStack(alignment: .leading, spacing: 20){
                Spacer()
                HStack{
                    BorderedTextField(title: "Name", placeholder: "Enter name of assignment", text: $name)
                }
                Spacer()
                VStack(alignment: .leading){
                    BorderedTextEditor(title: "Description", text: $description)
                }
                
                Spacer()
                VStack{
                    Text("Select a course").font(.headline)
                    Picker("Select a course", selection: $selectedCourseId) {
                        ForEach(UserDataManager.shared.getCourses(), id: \.id) { course in
                            Text(course.name)
                            
                        }
                    }
                }
                
                VStack(alignment: .leading){
                    Text("Due date:").font(.headline).multilineTextAlignment(.leading)
                    DatePicker("", selection: $dueDate).labelsHidden()
                }
                Spacer()
                
                TextButton(title: "Submit", foregroundColor: .white, backgroundColor: .pink, action: addAssignment)
                Spacer()
            }.padding(20)
        }.toast(isPresenting: $showSuccess){
            AlertToast(type: .complete(.blue), title: "Assignment update")
        }.toast(isPresenting: $showFailure){
            AlertToast(type: .error(.red), title: "Unable to update assignment")
        }
        
    }
    
    private func addAssignment() {
        print(selectedCourseId)
        UserDataManager.shared.updateAssignment(assignmentId: assignment.id, name: name, description: description, courseId: selectedCourseId, dueDate: dueDate) { assignment in
            showSuccess.toggle()
        } onfailure: {
            showFailure.toggle()
        }

    }
}

#Preview {
    EditAssignmentView(assignment: Assignment.dummyAssignment)
}
