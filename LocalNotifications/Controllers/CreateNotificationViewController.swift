//
//  CreateNotificationViewController.swift
//  LocalNotifications
//
//  Created by Matthew Ramos on 2/20/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

protocol CreateNotificationControllerDelegate: AnyObject {
    func didCreateNotification(_ createNotificationController: CreateNotificationViewController)
}

class CreateNotificationViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private var timeInterval: TimeInterval! = Date().timeIntervalSinceNow + 8
    
    weak var delegate: CreateNotificationControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func createLocalNotification() {
        // step 1:
        let content = UNMutableNotificationContent()
        content.title = titleTextField.text ?? "No Title Given."
        content.body = "Local Notifications is awesome"
        content.subtitle = "Learning Local Notifications"
         
        // TODO: userInfo Dictionary
    //    content.userInfo =
         
        // step 2: create identifier
        let identifier = UUID().uuidString // unique string
         
        // attatchment
        if let imageURL = Bundle.main.url(forResource: "duck", withExtension: "png") {
          do {
            let attatchment = try UNNotificationAttachment(identifier: identifier, url: imageURL, options: nil)
            content.attachments = [attatchment]
          } catch {
            print("error getting attatchment: \(error)")
          }
        } else {
          print("image resource could not be found")
        }
         
        // create trigger - time interval, calendar, location
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
         
        // create request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
         
        // add request to UNNotificationCenter
        UNUserNotificationCenter.current().add(request) { (error) in
          if let error = error {
            print("error adding request: \(error)")
          } else {
            print("request was successfully added")
          }
        }
         
      }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        //to avoid time being in the past
        guard sender.date > Date() else { return }
        
        timeInterval = sender.date.timeIntervalSinceNow
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        createLocalNotification()
        delegate?.didCreateNotification(self)
        dismiss(animated: true)
    }
    
}
