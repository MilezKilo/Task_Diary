//
//  TaskManager.swift
//  TasksDiary
//
//  Created by Макс Понизов on 12.03.2025.
//

import SwiftUI
import CoreData

class TaskManager: ObservableObject {
    var tasks: [TaskEntity] = []
    
    //Coredata container for tasks
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Task")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Cant load core data entity: \(error.localizedDescription)")
            }
        }
         fetchData()
    }
    
    
    //MARK: - PUBLIC METHODS
    ///Method that fetching data from the coredata container method.
    public func fetchData() {
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        do {
            tasks = try container.viewContext.fetch(request)
        } catch let error {
            print("Extraction data error: \(error.localizedDescription)")
        }
    }
    
    ///Method that saving data to container, used in every methods which manipulate the container.
    public func save() {
        do {
            try container.viewContext.save()
            fetchData()
        } catch let error {
            print("Save data error: \(error.localizedDescription)")
        }
    }
    
    ///Method that add new task to the coredata container.
    public func addTask(
        title: String,
        describe: String,
        type: String,
        date: Date,
        color: Color) -> TaskEntity {
            
            let newTask = TaskEntity(context: container.viewContext)
            
            newTask.taskID = UUID().uuidString
            newTask.title = title
            newTask.describe = describe
            newTask.type = type
            newTask.date = date
            newTask.isComplite = false
            
            switch color {
            case .red:
                newTask.priority = "high"
            case .yellow:
                newTask.priority = "medium"
            case .blue:
                newTask.priority = "low"
            default:
                newTask.priority = "zero"
            }
            
            save()
            return newTask
        }
    
    ///Method that return color for the task in the row.
    public func taskColor(entity: TaskEntity) -> Color {
        switch entity.priority {
        case "high":
            return Color.red
        case "medium":
            return Color.yellow
        case "low":
            return Color.blue
        default:
            return Color.white
        }
    }
    
    ///Method that return string for title of the task.
    public func taskType(entity: TaskEntity) -> String {
        switch entity.type {
        case "person.3":
            return "Work Task"
        case "book":
            return "Study and learn"
        case "cart":
            return "Visit a store"
        case "phone":
            return "Business call"
        case "cross":
            return "Visit a doctor"
        case "house":
            return "Household"
        default:
            return ""
        }
    }

    ///Method that update isComplite for each entity in the container.
    public func updateStatus(entity: TaskEntity) {
        entity.isComplite.toggle()
        save()
    }
    
    
    //MARK: - STATIC METHODS
    ///Static method that return array of tuples, which contains types of the tasks (String, String).
    static func types() -> [(String, String)] {
        [
            ("person.3", "Work Task"), ("book", "Study and learn"),
            ("cart", "Visit a store"), ("phone", "Business call"),
            ("cross", "Visit a doctor"), ("house", "Household")
        ]
    }
    
    ///Static method that return array of tuples, which contains string and color priority (String, Color)
    static func priorities() -> [(String, Color)] {
        [
            ("High", Color.red),
            ("Medium", Color.yellow),
            ("Low", Color.blue)
        ]
    }
    
    
    //MARK: - TEST METHODS
    static func printAllTasks(tsks: [TaskEntity]) {
        for task in tsks {
            print("TASK: \(task.title!), ID: \(task.taskID!)")
        }
    }
}


//MARK: - DEPRICATED
/*
 ///Method that delete specific entity from the container.
    public func delete(index: IndexSet) {
        guard let index = index.first else { return }
        let task = tasks[index]
        container.viewContext.delete(task)
        save()
    }
 
 ///Method that return "systemImage" based on task type
 public func taskType(entity: TaskEntity) -> String {
     switch entity.type {
     case "Work":
         return "person.3"
     case "Study":
         return "book"
     case "Shop":
         return "cart"
     case "Call":
         return "phone"
     case "Health":
         return "cross"
     case "Household":
         return "house"
     default:
         return "xmark"
     }
 }
 */
