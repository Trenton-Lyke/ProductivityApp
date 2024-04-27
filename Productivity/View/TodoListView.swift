//
//  TasksView.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/27/24.
//

import SwiftUI

struct TodoListView: View {
    private let tasks: [Task]
    
    init(tasks: [Task]) {
        self.tasks = tasks
    }
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    PreviewTaskListView(tasks: tasks)
                    NavigationLink {
                        CreateTaskView(task: nil)
                    } label: {
                        createTaskButton
                    }
                }
            }.navigationTitle("TODO List")
                .navigationBarTitleDisplayMode(.large)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(
                    .blue,
                    for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    var createTaskButton: some View {
        Text("+ Add New Task").font(.title2)
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
}

#Preview {
    TodoListView(tasks: [Task.dummyParentTask, Task.dummyParentTask,Task.dummyParentTask,Task.dummyParentTask,Task.dummyParentTask,Task.dummyParentTask,Task.dummyParentTask,Task.dummyParentTask,Task.dummyParentTask,Task.dummyParentTask])
}
