//
//  TaskDescriprion.swift
//  TasksDiary
//
//  Created by Макс Понизов on 28.03.2025.
//

import SwiftUI

struct TaskDescriprion: View {
    
    //MARK: - PROPERTIES
    @State var task: TaskEntity
    @State private var showTimeView: Bool = false
    
    @EnvironmentObject private var taskManager: TaskManager
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                typeAndBackButtonSection
                    .padding(.top, 10)
                    .padding(.horizontal)
                    .padding(.bottom, 25)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(taskManager.taskColor(entity: task))
                            .ignoresSafeArea()
                    }
                
                changableTitleSection
                    .modifier(SectionRectangle(color: .adaptive))
                
                changablePrioritySection
                    .modifier(SectionRectangle(color: taskManager.taskColor(entity: task)))
                
                changableDateSection
                    .modifier(SectionRectangle(color: .adaptive))
                
                if showTimeView {
                    HStack {
                        DatePicker(selection: Binding($task.date)!) {
                            Text("Change time")
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                
                changableDescriptionSection
                    .modifier(SectionRectangle(color: .adaptive))
                
                acceptButton
                    .padding(.leading)
                
                Spacer()
            }
            .navigationBarBackButtonHidden()
    }
}

//MARK: - VIEW EXTENSION
extension TaskDescriprion {
    private var typeAndBackButtonSection: some View {
        HStack(spacing: 25) {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.title2)
            }
            Spacer()
            //MAYBE DONT WORK
            Menu(content: {
                ForEach(TaskManager.types(), id: \.0) { type in
                    Button(action: {
                        self.task.type = type.0
                        self.taskManager.objectWillChange.send()
                    }) {
                        Label(type.1, systemImage: type.0)
                    }
                }
            }) {
                HStack(spacing: 20) {
                    Text(taskManager.taskType(entity: task))
                        .font(.title)
                    Image(systemName: task.type ?? "xmark")
                        .background {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(Color.type_img.opacity(0.75))
                                .shadow(radius: 1.5)
                        }
                }
            }
        }
    }
    
    private var changableTitleSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Title")
                    .font(.caption)
                    .padding(.bottom, 5)
                Spacer()
                Image(systemName: "lightbulb.max")
            }
            TextField("", text: Binding($task.title)!)
        }
    }
    
    private var changablePrioritySection: some View {
        Menu {
            ForEach(["low", "medium", "high"], id: \.self) { priority in
                Button(action: {
                    self.task.priority = priority
                    self.taskManager.objectWillChange.send()
                }) {
                    Text(priority)
                }
            }
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Text("Priority")
                        .font(.caption)
                        .padding(.bottom, 5)
                    Spacer()
                    Image(systemName: "exclamationmark.triangle")
                }
                Text("\(task.priority ?? "High")")
            }
            .foregroundStyle(taskManager.taskColor(entity: task))
        }

    }
    
    private var changableDateSection: some View {
        Button(action: {
            self.showTimeView.toggle()
        }) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Deadline")
                        .font(.caption)
                        .padding(.bottom, 5)
                    Spacer()
                    Image(systemName: "clock")
                }
                Text("\(Date.shortDateStyle(date: task.date ?? Date()))")
            }
        }
    }
    
    private var changableDescriptionSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Description")
                    .font(.caption)
                    .padding(.bottom, 5)
                Spacer()
                Image(systemName: "questionmark.diamond")
            }
            
            TextEditor(text: Binding($task.describe)!)
        }
    }
    
    private var acceptButton: some View {
        Button(action: {
            self.taskManager.save()
            self.taskManager.objectWillChange.send()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Save changes!")
                .textCase(.uppercase)
                .frame(
                    width: UIScreen.main.bounds.width * 0.90,
                    height: 55)
                .background(taskManager.taskColor(entity: task).cornerRadius(10))
                .padding(.vertical)
        }
    }
}

//MARK: - PREVIEW
struct TaskDescriprion_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            TaskDescriprion(task: TaskManager().tasks.first!)
                .preferredColorScheme(.light)
                .environmentObject(TaskManager())
            TaskDescriprion(task: TaskManager().tasks.first!)
                .preferredColorScheme(.dark)
                .environmentObject(TaskManager())
        }
    }
}


//MARK: - DEPRICATED
/*
 private var prioritySection: some View {
     VStack(alignment: .leading) {
         HStack {
             Text("Priority")
                 .font(.caption)
                 .padding(.bottom, 5)
             Spacer()
             Image(systemName: "exclamationmark.triangle")
         }
         Text("\(task.priority ?? "High")")
     }
     .foregroundStyle(taskManager.taskColor(entity: task))
 }
 
 private var titleSection: some View {
     VStack(alignment: .leading) {
         HStack {
             Text("Title")
                 .font(.caption)
                 .padding(.bottom, 5)
             Spacer()
             Image(systemName: "lightbulb.max")
         }
             Text("\(task.title ?? "TITLE")")
     }
 }
 
 private var descriptionSection: some View {
     VStack(alignment: .leading) {
         HStack {
             Text("Description")
                 .font(.caption)
                 .padding(.bottom, 5)
             Spacer()
             Image(systemName: "questionmark.diamond")
         }
         
         Text(task.describe ?? "some long description, that useful for debugging view frame")
     }
 }
 
 private var dateSection: some View {
     VStack(alignment: .leading) {
         HStack {
             Text("Deadline")
                 .font(.caption)
                 .padding(.bottom, 5)
             Spacer()
             Image(systemName: "clock")
         }
         Text("\(Date.shortDateStyle(date: task.date ?? Date()))")
     }
 }
 */
