//
//  Main.swift
//  TasksDiary
//
//  Created by Макс Понизов on 12.03.2025.
//

import SwiftUI

struct Main: View {
    
    //MARK: - PROPERTIES
    //State variables that contains current date and bool that manipulating alert for deleting tasks.
    @State private var currentDay: Date = .init()
    @State private var showDeleteAlert: Bool = false
    
    //Environment variable that contain coredata entity and have all methods to manipulate it.
    @EnvironmentObject private var taskManager: TaskManager
    
    
    //MARK: - BODY
    var body: some View {
        NavigationStack {
            VStack {
                header
                    .padding([.horizontal, .bottom])
                    .padding(.top)
                    .background { headerBackground }
                
                datePicker
                
                timeLineScroll
                    .padding([.horizontal, .bottom])
            }
        }
        .onAppear { NotificationManager.instance.requestAuthorization() }
    }
}

//MARK: - VIEW EXTENSION
extension Main {
    private var header: some View {
        VStack(spacing: 20) {
            HStack {
                helpButton
                Spacer()
                addTaskButton
            }
            .offset(y: -5)
        }
    }
    private var datePicker: some View {
        DatePicker("Select a date", selection: $currentDay, displayedComponents: .date)
            .datePickerStyle(.compact)
            .padding([.horizontal, .vertical], 10)
            .background {
                headerBackground
            }
    }
    private var timeLineScroll: some View {
        ScrollView(.vertical, showsIndicators: false) {
            timeLine()
        }
    }
}

//MARK: - METHODS EXTENSION
extension Main {
    @ViewBuilder func TimeLineRow(_ date: Date) -> some View {
        HStack(alignment:.top) {
            Text(date.toString("h a"))
                .font(.system(size: 14, weight: .regular))
                .frame(width: 45, alignment: .leading)
            
            let calendar = Calendar.current
            let filteredTasks = taskManager.tasks.filter {
                if let hour = calendar.dateComponents([.hour], from: date).hour,
                   let taskHour = calendar.dateComponents([.hour], from: $0.date ?? Date()).hour,
                   hour == taskHour && calendar.isDate($0.date ?? Date(), inSameDayAs: currentDay){
                    return true
                }
                return false
            }
            
            if filteredTasks.isEmpty {
                lineStroke
            } else {
                VStack {
                    ForEach(filteredTasks) { task in
                        NavigationLink(destination: TaskDescriprion(task: task)) {
                            TaskTemplate(task: task)
                                .onLongPressGesture(minimumDuration: 0.75) {
                                    self.showDeleteAlert = true
                                }
                                .alert(isPresented: $showDeleteAlert) {
                                    self.deleteAlert(task)
                                }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 15)
    }
    @ViewBuilder func timeLine() -> some View {
        ScrollViewReader { proxy in
            let hours = Calendar.current.hours
//            let midHour = hours[hours.count / 2]
            VStack {
                ForEach(hours, id: \.self) { hour in
                    TimeLineRow(hour)
                        .id(hour)
                }
            }
//            .onAppear { proxy.scrollTo(midHour) }
        }
    }
    private func deleteAlert(_ task: TaskEntity) -> Alert {
        Alert(
            title: Text("Are you sure to delete this task?"),
            message: Text(""),
            primaryButton: .cancel(Text("Yes")) {
                taskManager.container.viewContext.delete(task)
                NotificationManager().deleteNotification(task: task)
                do {
                    try taskManager.container.viewContext.save()
                    taskManager.fetchData()
                } catch let error {
                    print("SAVE ERROR: \(error.localizedDescription)")
                }
            },
            secondaryButton: .default(Text("No"))
        )
    }
}

//MARK: - ELEMENTS EXTENSION
extension Main {
    private var helpButton: some View {
        NavigationLink(destination: HelpScreen()) {
            HStack {
                Image(systemName: "questionmark.circle")
                    .font(.title2)
                    .foregroundStyle(.imgAdaptive)
                Text("Help")
                    .font(.headline)
            }
        }
    }
    private var addTaskButton: some View {
        NavigationLink(destination: NewTask()) {
            HStack {
                Text("Add task")
                    .font(.headline)
                Image(systemName: "plus.circle")
                    .font(.title2)
                    .foregroundStyle(.imgAdaptive)
            }
        }
    }
    
    private var lineStroke : some View {
        return Rectangle()
            .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: 0.5, lineCap: .butt, lineJoin: .bevel, dash: [5], dashPhase: 5))
            .frame(height: 0.5)
            .offset(y: 10)
    }
    private var headerBackground: some View {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue)
                .ignoresSafeArea()
    }
}


//MARK: - PREVIEW
struct Main_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            Main()
                .preferredColorScheme(.light)
                .environmentObject(TaskManager())
            Main()
                .preferredColorScheme(.dark)
                .environmentObject(TaskManager())
        }
    }
}


//MARK: - DEPRICATED
/*
 State variable that contain bool which view with task description.
 @State private var showTaskScreen: Bool = false
 
 Button(action: {
     NotificationManager.instance.printAllNotifications()
     TaskManager.printAllTasksID(tsks: taskManager.tasks)
 }) {
     Text("check")
 }
 
 Button(action: {
     NotificationManager.instance.deleteAllNotifications()
 }) {
     Text("delete")
 }
 
TaskTemplate(task: task)
    .fullScreenCover(isPresented: $showTaskScreen) {
        TaskDescriprion(task: task, showTaskScreen: $showTaskScreen)
    }
    .onTapGesture {
        self.taskManager.objectWillChange.send()
        self.showTaskScreen.toggle()
    }
    .onLongPressGesture(minimumDuration: 0.75) {
        self.showDeleteAlert = true
    }
    .alert(isPresented: $showDeleteAlert) {
        self.deleteAlert(task)
    }
 */
