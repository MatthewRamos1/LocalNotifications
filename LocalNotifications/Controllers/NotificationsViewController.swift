//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Matthew Ramos on 2/20/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var notifications = [UNNotificationRequest]()
    private let nCenter = UNUserNotificationCenter.current()
    private let pendingNotification = PendingNotification()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkForNotificationAuthorization()
        loadNotifications()
    }
    
    private func loadNotifications() {
        pendingNotification.getPendingNotifications { (requests) in
            self.notifications = requests
        }
    }
    
    private func checkForNotificationAuthorization() {
        nCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                print("app is authorized for notifications")
            } else {
                self.requestNotificationPermissions()
            }
        }
    }
    
    private func requestNotificationPermissions() {
        nCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print("\(error)")
                return
            }
            if granted {
                print("granted")
            } else {
                print("Denied")
            }
        }
    }


}

extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath)
        return cell
    }
    
    
}

extension NotificationsViewController: UNUserNotificationCenterDelegate {
    
}
