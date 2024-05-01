//
//  EditCourseView.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import SwiftUI
import AlertToast

struct EditCourseView: View {
    var course: Course
    @State private var name: String
    @State private var description: String
    @State private var showSuccess = false
    @State private var showFailure = false
    
    init(course: Course) {
        self.course = course
        name = self.course.name
        description = self.course.description
    }
    
    var body: some View {
        NavigationView(title: "Edit Course") {
            VStack(alignment: .leading, spacing: 20){
                BorderedTextField(title: "Course name", placeholder: "Enter course name", text: $name)
                BorderedTextEditor(title: "Course description", text: $description)
            
                TextButton(title: "Submit", foregroundColor: .white, backgroundColor: .pink, action: editCourse)
                
                Spacer()
            }.padding(20)
        }.toast(isPresenting: $showSuccess){
            AlertToast(type: .complete(.blue), title: "Course updated")
        }.toast(isPresenting: $showFailure){
            AlertToast(type: .error(.red), title: "Unable to update course")
        }
    }
    
    private func editCourse() {
        print("create course button clicked: \(name); \(description)")
        UserDataManager.shared.updateCourse(courseId: course.id, name: name, description: description) { course in
            showSuccess.toggle()
        } onfailure: {
            showFailure.toggle()
        }
    }
}


#Preview {
    EditCourseView(course: Course.dummyCourse1)
}
