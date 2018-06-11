
import UIKit
import UserNotifications
import CoreLocation
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow()
        self.window?.makeKeyAndVisible()
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        if let city = FetchCities() {
            cities = city
        } else {
            cities = [String]()
        }
        
        if (UserDefaults.standard.bool(forKey: "firstTimeOpened")) {
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
        print("Will resign active")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("Did enter background")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //locationManager.requestAlwaysAuthorization()
        print("Will enter foreground")
        window?.makeKeyAndVisible()
        window?.rootViewController = ViewController()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("Did become active")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        SaveCity(cities: cities!)
        print("Will Terminate") // Practically never called
    }
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void) {
        
         let sc = SettingsViewController()
        
        completionHandler(.newData)
        let config = URLSessionConfiguration.background(withIdentifier: "bg")
        let session = URLSession(configuration: config)
        let comment =  NotificationComment(location: "Current location", session : session)
        
        scheduleNotification(atDate: createDate(hour: 22, minute: 17), title: "Notification", body : comment)
    }
    
}
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}
