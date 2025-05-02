//
//  TaskTemplate.swift
//  TasksDiary
//
//  Created by Макс Понизов on 16.03.2025.
//

import SwiftUI

struct TaskTemplate: View {
    
    //MARK: - PROPERTIES
    let task: TaskEntity
    @EnvironmentObject private var taskManager: TaskManager
    
    //MARK: - BODY
    var body: some View {
        taskView(task)
            .foregroundStyle(Color.adaptive)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background { taskBG(task) }
    }
}

//MARK: - METHODS EXTENSIONS
extension TaskTemplate {
    func taskView(_ task: TaskEntity) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(task.title?.uppercased() ?? "Study programming")
                    .font(.system(size: 16, weight: .regular))
                Spacer()
                Image(systemName: task.type ?? "xmark")
                    .background {
                        Circle()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color.type_img.opacity(0.75))
                            .shadow(radius: 1.5)
                    }
            }
            
            if task.description != "" {
                Text(task.describe ?? "I need to learn python programming, for build neural network.")
                    .font(.system(size: 14, weight: .light))
                    .multilineTextAlignment(.leading)
            }
        }
    }
    func taskBG(_ task: TaskEntity) -> some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(taskManager.taskColor(entity: task))
                .frame(width: 4)
            
            Rectangle()
                .fill(taskManager.taskColor(entity: task).opacity(0.15))
        }
    }
}


//MARK: - PREVIEW
struct TaskTemplate_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            TaskTemplate(task: TaskManager().tasks.first!)
                .preferredColorScheme(.light)
                .environmentObject(TaskManager())
            TaskTemplate(task: TaskManager().tasks.first!)
                .preferredColorScheme(.dark)
                .environmentObject(TaskManager())
        }
    }
}
