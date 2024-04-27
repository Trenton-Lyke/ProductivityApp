//
//  TaskPreviewView.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/27/24.
//

import SwiftUI

struct PreviewTaskView: View {
    private let task: Task
    
    init(task: Task) {
        self.task = task
    }
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(task.name).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "checkmark")
                        .imageScale(.large)
                        .foregroundStyle(.green)
                }
            }
            
            Text(task.description).font(.subheadline)
            Text("Due: \(task.dueDate)").font(.caption)
        }
        
    }
}

#Preview {
    PreviewTaskView(task: Task.dummyParentTask)
}
