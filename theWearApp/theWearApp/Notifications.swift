//
//  Notifications.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 11/06/2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit
import UserNotifications

func createDate(hour: Int, minute: Int) -> Date {
    
    var components = DateComponents()
    components.hour = hour
    components.minute = minute
    components.weekdayOrdinal = 10
    components.timeZone = .current
    
    let calendar = Calendar(identifier: .gregorian)
    return calendar.date(from: components)!
}

func scheduleNotification(atDate date: Date, body: String, title: String) {
    
    removeNotifications(withIdentifiers: ["weatherForecastNotification"])
    
    let triggerWeekly = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
    
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = UNNotificationSound.default()
    
    let request = UNNotificationRequest(identifier: "weatherForecastNotification", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { (error) in
        if let error = error {
            print("Error occured: \(error)")
        
        }
    }
}

func removeNotifications(withIdentifiers identifiers: [String]) {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: identifiers)
}
