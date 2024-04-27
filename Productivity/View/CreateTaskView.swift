//
//  CreateTaskView.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/27/24.
//

import SwiftUI
import AlertToast

struct CreateTaskView: View {
    private var isSubtask: Bool
    private var parentTaskId: Int
    @State private var showSuccess = false
    @State private var showFailure = false
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var dueDate: Date = Date()
    
    init(task: Task?) {
        isSubtask = false
        parentTaskId = -1
        
        if let parentTask = task {
            isSubtask = true
            parentTaskId = parentTask.id
        }
    }
    
    var body: some View {
        NavigationStack {
            List{
                CreateTaskForm(createTask: createTask, name: $name, description: $description, dueDate: $dueDate)
                
            }
            .navigationTitle("Create \(isSubtask ? "Subtask" : "Task")")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(
                .blue,
                for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            
            

        }.toast(isPresenting: $showSuccess){
            AlertToast(type: .complete(.blue), title: "Task Created!")
        }.toast(isPresenting: $showFailure){
            AlertToast(type: .error(.red), title: "Unable to Create Task")
        }
    }
    
    private func resetForm() {
        name = ""
        description = ""
        dueDate = Date()
    }
    
    private func createTask() {
        let taskParams = CreateTaskParameters(name: name, description: description, dueDate: dueDate, done: false, isSubtask: isSubtask, parentTaskId: parentTaskId)
        
        NetworkManager.shared.createTask(taskParameters: taskParams) { response in
            guard let task = response else {
                showFailure.toggle()
                return
            }
            showSuccess.toggle()
            resetForm()
        }


    }
}

struct CreateTaskForm: View {
    let createTask: () -> Void
    @Binding var name: String
    @Binding var description: String
    @Binding var dueDate: Date
    
    var body: some View {
        VStack(alignment: .leading){
            Spacer()
            HStack{
                Text("Name:").font(.headline)
                TextField("Enter name of task", text: $name)
            }
            Spacer()
            VStack(alignment: .leading){
                Text("Description:").font(.headline)
                TextEditor(text: $description).addBorder(.black, cornerRadius: 15).lineLimit(5).frame(height: 200)
            }
            Spacer()
            VStack(alignment: .leading){
                Text("Due Date:").font(.headline).multilineTextAlignment(.leading)
                DatePicker("", selection: $dueDate).labelsHidden()
            }
            Spacer()
            Button("Submit", action: createTask).buttonStyle(.borderedProminent).tint(.blue)
        }.padding(.horizontal, 16)
    }
}



#Preview {
    CreateTaskView(task: nil)
}
