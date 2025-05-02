//
//  NotificationManager.swift
//  TasksDiary
//
//  Created by Макс Понизов on 29.03.2025.
//

import Foundation
import NotificationCenter

class NotificationManager {
    
    //Singleton instance
    static let instance = NotificationManager()
    
    ///This method wiil used, when application launched for the first time.
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.badge, .sound, .alert]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("Installation error: \(error.localizedDescription)")
            } else {
                print("Successful installation of the notification center!")
            }
        }
    }
    
    ///This method add new notification, when user create new task.
    func scheduleTaskNotification(task: TaskEntity) {
        let content = UNMutableNotificationContent()
        content.title = task.title!
        content.subtitle = task.describe ?? ""
        content.sound = .default
        content.badge = 1
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.timeZone, .year, .month, .day, .hour, .minute], from: task.date ?? Date()), repeats: false)
        
        let id = task.taskID!
        
        let request = UNNotificationRequest(
                    identifier: id,
                    content: content,
                    trigger: trigger)
                
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Create notification error: \(error.localizedDescription)")
            } else {
                print("Notification has been created with ID: \(id)")
            }
        }
    }
    
    ///This method will delete current notification from notifications schedule.
    func deleteNotification(task: TaskEntity) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [task.taskID!])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.taskID!])
        print("TASK HAS BEEN DELETED: \(task.taskID!)")
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("Оставшиеся уведомления: \(requests.map { $0.identifier })")
        }
    }
    
    //MARK: - TEST METHODS
    func printAllNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("Remaining notifications: \(requests.map { $0.identifier })")
        }
    }
    func deleteAllNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("All notifications has been deleted")
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("Remaining notifications: \(requests.map { $0.identifier })")
        }
    }
}

//MARK: - DEPRICATED
/*
 ///This method add new notification, when user create new task (based not on task entity but on title/date/etc.).
 func scheduleNotification(title: String, describe: String, date: Date, id: String) {
     let content = UNMutableNotificationContent()
     content.title = title
     content.subtitle = describe
     content.sound = .default
     content.badge = 1
     
     let trigger = UNCalendarNotificationTrigger(
         dateMatching: Calendar.current.dateComponents([.timeZone, .year, .month, .day, .hour, .minute], from: date), repeats: false)
     
     let request = UNNotificationRequest(
         identifier: id,
         content: content,
         trigger: trigger)
     
     UNUserNotificationCenter.current().add(request)
 }
 */
