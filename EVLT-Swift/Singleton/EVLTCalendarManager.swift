//
//  EVLTCalendarManager.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 3/21/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import Foundation
import GoogleAPIClient
import GTMOAuth2

class EVLTCalendarManager: NSObject {
    //MARK: Properties
    private let kKeychainItemName = "Google Calendar API"
    private let kClientID = "340967554983-7fhuo5ds1kgf0heo2jkv6v95k8qe47fu.apps.googleusercontent.com"
    private let scopes = [kGTLAuthScopeCalendarReadonly]
    private let service = GTLServiceCalendar()
    
    //MARK: Singleton
    static let sharedInstance : EVLTCalendarManager = {
        let instance = EVLTCalendarManager()
        return instance
    }()
    
    
    //MARK: Methods
    func loadProjects(forDate date:Date, completion: (_ projects: [Project]) -> Void) {
        let projects = [Project]()
        completion(projects)
    }
    
    override init() {
        super.init()
    }
    
    //Configure CalendarManager
    func setup(controller: UIViewController) {
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychain(
            forName: kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            service.authorizer = auth
        }
        
        if let authorizer = service.authorizer,
            let canAuth = authorizer.canAuthorize, canAuth {
            fetchEvents()
        } else {
            controller.present(
                createAuthController(),
                animated: true,
                completion: nil
            )
        }
    }
    
    // Construct a query and get a list of upcoming events from the user calendar
    func fetchEvents() {
        let query = GTLQueryCalendar.queryForEventsList(withCalendarId: "primary")
        query?.maxResults = 10
        query?.timeMin = GTLDateTime(date: NSDate() as Date!, timeZone: NSTimeZone.local)
        query?.singleEvents = true
        query?.orderBy = kGTLCalendarOrderByStartTime
        service.executeQuery(
            query!,
            delegate: self,
            didFinish: #selector(EVLTCalendarManager.displayResultWithTicket(ticket:finishedWithObject:error:)) 
        )
    }
    
    // Creates the auth controller for authorizing access to Google Calendar API
    private func createAuthController() -> GTMOAuth2ViewControllerTouch {
        let scopeString = scopes.joined(separator: " ")
        return GTMOAuth2ViewControllerTouch(
            scope: scopeString,
            clientID: kClientID,
            clientSecret: nil,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: Selector(("viewController:finishedWithAuth:error:"))
        )
    }
    
    
    // Handle completion of the authorization process, and update the Google Calendar API
    // with the new credentials.
    func viewController(vc : UIViewController,
                        finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
        
        if let error = error {
            service.authorizer = nil
            showAlert(controller:vc, title: "Authentication Error", message: error.localizedDescription)
            return
        }
        
        service.authorizer = authResult
        vc.dismiss(animated: true, completion: nil)
    }
    
    // Helper for showing an alert
    func showAlert(controller: UIViewController,  title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        controller.present(alert, animated: true, completion: nil)
    }
    
    // Display the start dates and event summaries in the UITextView
    func displayResultWithTicket(
        ticket: GTLServiceTicket,
        finishedWithObject response : GTLCalendarEvents,
        error : NSError?) {
        
        if let error = error {
            //showAlert(controller: controller, title: "Error", message: error.localizedDescription)
            return
        }
        
        var eventString = ""
        
        if let events = response.items(), !events.isEmpty {
            for event in events as! [GTLCalendarEvent] {
                let start : GTLDateTime! = event.start.dateTime ?? event.start.date
                let startString = DateFormatter.localizedString(
                    from: start.date,
                    dateStyle: .short,
                    timeStyle: .short
                )
                eventString += "\(startString) - \(event.summary)\n"
            }
        } else {
            eventString = "No upcoming events found."
        }
        
        print(eventString)
    }

}
