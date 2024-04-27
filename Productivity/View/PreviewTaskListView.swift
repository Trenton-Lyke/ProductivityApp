//
//  PreviewTaskListView.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/27/24.
//

import SwiftUI

struct PreviewTaskListView: View {
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    
    private let tasks: [Task]
    
    init(tasks: [Task]) {
        self.tasks = tasks
    }
    
    var body: some View {
        List{
            ForEach(tasks, id: \.self){ task in
                PreviewTaskView(task: task)
            }.listRowSeparator(.hidden)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 5)
                        .background(.clear)
                        .foregroundColor(.white)
                        .padding(
                            EdgeInsets(
                                top: 2,
                                leading: 10,
                                bottom: 2,
                                trailing: 10
                            )
                        )
                    )
        }.frame(minHeight: minRowHeight * 10)
    }
}

#Preview {
    PreviewTaskListView(tasks: [Task.dummyParentTask, Task.dummyParentTask,Task.dummyParentTask,Task.dummyParentTask,Task.dummyParentTask,Task.dummyParentTask,Task.dummyParentTask,Task.dummyParentTask,Task.dummyParentTask,Task.dummyParentTask])
}
