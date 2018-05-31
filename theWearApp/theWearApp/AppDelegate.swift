//
//  AppDelegate.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 23.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//
//
import UIKit
import UserNotifications
import CoreLocation
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var locationManager = CLLocationManager()
    var window: UIWindow?
    let center = UNUserNotificationCenter.current()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
        self.center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
           
        }
        if (CheckInternet.Connection())
        {  scheduleNotification(at: createDate( hour: 8, minute: 30), body: "New notification", titles: "Hello, programmers!")}
        else
        {
            let alert = UIAlertController(title: "Error", message: "Sorry, no onternet connection!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            alert.present(alert, animated: true)
            applicationWillTerminate(application)
        }
            self.window = UIWindow()
            self.window?.makeKeyAndVisible()
        
        if let city = FetchCities() {
            cities = city
        } else {
            cities = [String]()
        }
        
        if !(UserDefaults.standard.bool(forKey: "firstTimeOpened")) {
            self.locationManager.requestAlwaysAuthorization()
            self.window?.rootViewController = ViewController()
        } else {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let welcomePage = WelcomePage(collectionViewLayout: layout)
            self.window?.rootViewController = welcomePage
        }
        return true
    }

   
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        SaveCity(cities: cities!)
    }
    func createDate(hour: Int, minute: Int)->Date{
        
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        components.weekdayOrdinal = 10
        components.timeZone = .current
        
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: components)!
    }//
    //Schedule Notification with weekly bases.
    func scheduleNotification(at date: Date, body: String, titles:String) {
        
        let triggerWeekly = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
        ////
        let content = UNMutableNotificationContent()
        content.title = titles
        content.body = body
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "todoList"
        
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print(" We had an error: \(error)")
            }
        }
    }
}
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}
