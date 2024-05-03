//
//  EditCourseView.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import SwiftUI
import AlertToast

struct EditCourseView: View {
    var courseId: Int
    @State private var name: String
    @State private var code: String
    @State private var description: String
    @State private var showSuccess = false
    @State private var showFailure = false
    private var currentCourse: Course
    
    init(courseId: Int) {
        self.courseId = courseId
        currentCourse = UserDataManager.shared.getCourse(id: courseId)
        name = currentCourse.name
        code = currentCourse.code
        description = currentCourse.description
    }
    
    var body: some View {
        NavigationView(title: "Edit Course") {
            VStack(alignment: .leading, spacing: 20){
                BorderedTextField(title: "Course name", placeholder: "Enter course name", text: $name)
                BorderedTextField(title: "Course code", placeholder: "Enter course code", text: $code)
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
        UserDataManager.shared.updateCourse(courseId: courseId, name: name, code: code, description: description) { course in

            showSuccess.toggle()
        } onfailure: {
            showFailure.toggle()
        }
    }
}

