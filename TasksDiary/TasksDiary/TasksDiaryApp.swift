//
//  TasksDiaryApp.swift
//  TasksDiary
//
//  Created by Макс Понизов on 12.03.2025.
//

import SwiftUI

@main
struct TasksDiaryApp: App {
    
    //MARK: - PROPERTIES
    @StateObject private var taskManager: TaskManager = TaskManager()
    @State private var showLaunch: Bool = true
    
    
    //MARK: - BODY
    var body: some Scene {
        WindowGroup {
            if showLaunch {
                Greetings(showScreen: $showLaunch)
                    .transition(.opacity)
            } else {
                Main()
                    .environmentObject(taskManager)
            }
        }
    }
}

//MARK: - TODO
//DONE
// 1 - DELETE NOTIFICATION METHOD
// 2 - CHANGE TASK FIELDS FEATURE
// 3 - FIX TASK DESCRIPTION VIEW BUG

//NOT DONE
// 4 - DESIGN IN FIGMA
// 5 - CODE REFACTORING















