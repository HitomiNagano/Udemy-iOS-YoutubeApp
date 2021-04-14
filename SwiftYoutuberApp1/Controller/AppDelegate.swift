//
//  AppDelegate.swift
//  SwiftYoutuberApp1
//
//  Created by Hitomi Nagano on 2021/04/13.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // push 通知を 19:00 に固定すると仮定
    let hour = 19
    let minute = 00
    
    var isGrantedNotification = true
    // アプリが初回起動時かどうか？
    var isFirstLaunched = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 許可を促すアラートを表示
        // 参考：https://qiita.com/aokiplayer/items/3f02453af743a54de718
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            self.isGrantedNotification = granted
            if let error = error {
                print(error)
            }
        }
        self.isFirstLaunched = false
        setNotification()
        
        return true
    }
    
    func setNotification() {
        var notificationTime = DateComponents()
        var trigger: UNNotificationTrigger
        
        notificationTime.hour = hour
        notificationTime.minute = minute
        trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "19時になりました"
        content.body = "ニュースが更新されました"
        content.sound = .default

        let request = UNNotificationRequest(identifier: "uuid", content: content, trigger: trigger)
        // 通知をセット
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // 完全にアプリが閉じられた時でも通知させたい
    func applicationDidEnterBackground(_ application: UIApplication) {
        setNotification()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

