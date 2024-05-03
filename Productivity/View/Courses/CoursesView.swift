//
//  ClassesView.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import SwiftUI

struct CoursesView: View {
    @StateObject private var userManager = UserDataManager.shared
    
    var body: some View {
        NavigationView(title: "Courses") {
            List {
                Section {
                    ForEach(userManager.getCourses(), id: \.self) { course in
                        CourseRow(course: course)
                    }
                }

                if userManager.isLoggedIn() {
                    NavigationLink {
                        CreateCourseView(isTemporaryWindow: false)
                    } label: {
                        Label("Add new course", systemImage: "plus")
                            .foregroundStyle(.blue)
                    }
                } else {
                    NavigationLink {
                        AccountView(isTemporaryAuth: true)
                    } label: {
                        Text("Login to view courses")
                            .foregroundStyle(.blue)
                    }
                }
                
                
            }
        }
    }
}

struct CourseRow: View {
    let course: Course
    
    
    var body: some View {
        NavigationLink {
            CourseView(courseId: course.id)
        } label: {
            HStack{
                Text("\(course.name) (\(course.code))")
                Spacer()
                Image(systemName: "trash")
                    .imageScale(.large)
                    .foregroundStyle(.red)
                    .onTapGesture {
                        UserDataManager.shared.deleteCourse(courseId: course.id, onsuccess: {_ in }, onfailure: {})
                    }
            }
        }
    }
}



#Preview {
    CoursesView()
}
