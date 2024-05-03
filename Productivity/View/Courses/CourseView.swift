//
//  CourseView.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import SwiftUI

struct CourseView: View {
    var courseId: Int
    @StateObject private var userManager = UserDataManager.shared
    
    var body: some View {
        NavigationView(title: "Course") {
            Spacer()
            VStack{
                HStack{
                    Text("\(userManager.getCourse(id: courseId).name) \(userManager.getCourse(id: courseId).code)")
                        .font(.largeTitle)
                    NavigationLink {
                        EditCourseView(courseId: courseId)
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .imageScale(.large)

                    }
                }
                
                Spacer()
                Text(userManager.getCourse(id: courseId).description)
                List {
                    Section {
                        ForEach(userManager.getCourse(id: courseId).assignments, id: \.self) { assignment in
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
