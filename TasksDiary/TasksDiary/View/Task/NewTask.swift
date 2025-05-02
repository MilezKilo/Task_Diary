//
//  TestView.swift
//  TasksDiary
//
//  Created by Макс Понизов on 17.03.2025.
//

import SwiftUI

///Contains several alert types for add task view
enum AlertType {
    case add
    case error
}

struct NewTask: View {
    
    //MARK: - PROPERTIES
    @EnvironmentObject private var taskManager: TaskManager
    @Environment(\.presentationMode) private var presentationMode
    
    //Properties for creating new task.
    @State private var title: String = ""
    @State private var describe: String = ""
    @State private var type: String = "cart"
    @State private var date: Date = Date()
    @State private var priority: Color = Color.red
    
    //Bool property that show alert
    @State private var showAlert: Bool = false
    @State private var currentAlert: AlertType = .add
    
    
    //MARK: - BODY
    var body: some View {
        VStack(spacing: 15) {
            header
                .padding(.horizontal)
                .frame(height: 100)
                .background { headerBG }
            
            pickersView
                .padding(.horizontal)
            
            priorityColorsView
                .padding(.horizontal)
            
            titleView
            
            DescriptionView
                .padding(.horizontal)
                    
            addTaskButton
                .alert(isPresented: $showAlert) {
                    deleteAlert(currentAlert: currentAlert)
                }
                .padding(.horizontal)
        }
        .navigationBarBackButtonHidden()
    }
}

//MARK: - VIEW EXTENSION
extension NewTask {
    //Header views
    private var header: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                }
                Spacer()
            }
            
            HStack {
                Text("NEW TASK")
                    .font(.title)
                    .bold()
                Spacer()
            }
            Spacer()
        }
    }
    private var headerBG: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.blue)
            .ignoresSafeArea()
    }
    
    //Task elements View
    private var pickersView: some View {
        VStack {
            HStack {
                Text("Date and type")
                    .font(.subheadline)
                Spacer()
            }
            HStack {
                DatePicker("", selection: $date)
                Picker("", selection: $type) {
                    ForEach(TaskManager.types(), id: \.0) { type in
                        HStack {
                            Text(type.1)
                            Image(systemName: type.0)
                        }
                    }
                }
                .pickerStyle(.menu)
            }
        }
    }
    private var priorityColorsView: some View {
        VStack {
            HStack {
                Text("Priority")
                    .font(.subheadline)
                Spacer()
            }
            
            HStack(spacing: 5) {
                ForEach(TaskManager.priorities(), id: \.1) { priorityCl in
                    ZStack {
                        Text(priorityCl.0)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(priorityCl.1.opacity(priority == priorityCl.1 ? 0.5 : 0.1))
                            .frame(height: 40)
                            .onTapGesture {
                                withAnimation {
                                    priority = priorityCl.1
                                }
                            }
                    }
                }
            }
        }
    }
    private var titleView: some View {
        VStack {
            HStack {
                Text("Title")
                    .font(.subheadline)
                Spacer()
            }
            .padding(.horizontal)
            ZStack {
                TextField("Enter a title", text: $title)
                    .padding(.horizontal, 25)
                
                RoundedRectangle(cornerRadius: 10)
                    .stroke()
                    .frame(height: 45)
                    .padding(.horizontal, 15)
            }
        }
    }
    private var DescriptionView: some View {
        VStack {
            HStack {
                Text("Description")
                    .font(.subheadline)
                Spacer()
            }
            TextEditor(text: $describe)
                .background(Color.black)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                }
        }
    }
    private var addTaskButton: some View {
        Button(action: {
            addNewTask(
                title: self.title,
                decribe: self.describe,
                type: self.type,
                date: self.date,
                priority: self.priority)
        }) {
            Text("ADD TASK")
                .frame(
                    width: UIScreen.main.bounds.width * 0.925,
                    height: 55)
                .background(Color.blue.cornerRadius(10))
                .padding(.vertical)
        }
    }
}

//MARK: - METHODS EXTENSION
extension NewTask {
    private func addNewTask(
        title: String,
        decribe: String,
        type: String,
        date: Date,
        isComplite: Bool = false,
        priority: Color) {
            guard title.count > 2 else {
                currentAlert = .error
                showAlert.toggle()
                return
            }
            
            self.currentAlert = .add
            
            let newTask = taskManager.addTask(
                title: title,
                describe: describe.count == 0 ? "" : describe,
                type: type,
                date: date,
                color: priority)
            
            NotificationManager.instance.scheduleTaskNotification(task: newTask)
            
            showAlert.toggle()
    }
    private func deleteAlert(currentAlert: AlertType) -> Alert {
        switch currentAlert {
        case .add:
            Alert(
                title: Text("New Task has been added"),
                message: nil,
                dismissButton: .default(Text("Understand"), action: {
                    self.taskManager.objectWillChange.send()
                    presentationMode.wrappedValue.dismiss()
                }))
        case .error:
            Alert(
                title: Text("The task should have a title"),
                message: Text("Or title is too short!"),
                dismissButton: .default(Text("Understand")))
        }
    }
}

//MARK: - PREVIEW
struct NewTask_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            NewTask()
                .preferredColorScheme(.light)
                .environmentObject(TaskManager())
            NewTask()
                .preferredColorScheme(.dark)
                .environmentObject(TaskManager())
        }
    }
}
