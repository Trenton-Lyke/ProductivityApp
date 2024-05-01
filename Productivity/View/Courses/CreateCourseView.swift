//
//  CreateCourseView.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import SwiftUI
import AlertToast

struct CreateCourseView: View {
    var isTemporaryWindow: Bool
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var showSuccess = false
    @State private var showFailure = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView(title: "Create Course") {
            VStack(alignment: .leading, spacing: 20){
                BorderedTextField(title: "Course name", placeholder: "Enter course name", text: $name)
                BorderedTextEditor(title: "Course description", text: $description)
            
                TextButton(title: "Submit", foregroundColor: .white, backgroundColor: .pink, action: createCourse)
                
                Spacer()
            }.padding(20)
        }.toast(isPresenting: $showSuccess){
            AlertToast(type: .complete(.blue), title: "Course created and added")
        }.toast(isPresenting: $showFailure){
            AlertToast(type: .error(.red), title: "Unable to create course")
        }
    }
    
    private func createCourse() {
        print("create course button clicked: \(name); \(description)")
        UserDataManager.shared.createCourse(name: name, description: description) { course in
            name = ""
            description = ""
            
            if isTemporaryWindow {
                self.presentationMode.wrappedValue.dismiss()
            } else {
                showSuccess.toggle()
            }
            
        } onfailure: {
            showFailure.toggle()
        }
    }
}

#Preview {
    CreateCourseView(isTemporaryWindow: false)
}
