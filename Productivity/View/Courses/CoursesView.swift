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
                    ForEach(userManager.getCourses(), id: \.id) { course in
                        NavigationLink {
                            CourseView(course: course)
                        } label: {
                            HStack{
                                Text(course.name)
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

#Preview {
    CoursesView()
}
