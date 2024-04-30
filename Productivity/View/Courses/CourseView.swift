//
//  CourseView.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import SwiftUI

struct CourseView: View {
    var course: Course
    
    var body: some View {
        NavigationView(title: "Course") {
            Spacer()
            VStack{
                HStack{
                    Text(course.name)
                        .font(.largeTitle)
                    NavigationLink {
                        EditCourseView(course: course)
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .imageScale(.large)

                    }
                }
                
                Spacer()
                Text(course.description)
                List {
                    Section {
                        ForEach(course.assignments, id: \.id) { assignment in
                            HStack{
                                Text(assignment.name)
                            }
                        }
                    } header: {
                        Text("Assignments")
                    }
                }
            }            
        }
            
    }
}

#Preview {
    CourseView(course: Course.dummyCourse1)
}
