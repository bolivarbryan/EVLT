//
//  CalendarViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/30/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit
import JTCalendar
import CoreFoundation
import DateTools

class CalendarViewController: UIViewController, JTCalendarDelegate {
    @IBOutlet weak var calendarContentView: JTHorizontalCalendarView!
    @IBOutlet weak var calendarMenuView: JTCalendarMenuView!
    var calendarManager:JTCalendarManager!
    @IBOutlet weak var tableView: UITableView!
    let eventsByDate:NSMutableDictionary = NSMutableDictionary()
    var calendarEvents = [EVLTCalendar]()
    
    let todayDate = NSDate()
    var minDate = NSDate()
    var maxDate = NSDate()
    
    var dateSelected:NSDate? = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.calendarManager = JTCalendarManager()
        self.calendarManager.delegate = self
        calendarManager.menuView = self.calendarMenuView
        calendarManager.contentView = calendarContentView

        self.configureDate(date: NSDate())
        calendarManager.setDate(todayDate as Date!)
        
        //call google calendar api
        //EVLTCalendarManager.sharedInstance.setup(controller: self)
        
        //Loading dates from server
        fetchEventsForDate(date: Date())
        
        //update UI
        refreshTitleMonthFromCurrentCalendarPage()

    }
    
    //Load from api
    func fetchEventsForDate(date: Date) {
        APIRequests.getDate(date: date) { (results) in
            let calendarObjects = (results as! [String: Any])["results"] as! [[String: Any]]
            self.calendarEvents = calendarObjects.map { calendar -> EVLTCalendar in
                print(calendar)
               return EVLTCalendar(dictionary: calendar)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    func configureDate(date: NSDate) {
        minDate = calendarManager.dateHelper.add(to: todayDate as Date!, days: -2) as NSDate
        maxDate = calendarManager.dateHelper.add(to: todayDate as Date!, days: 2) as NSDate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: calendar
    func refreshTitleMonthFromCurrentCalendarPage() {
        let formatter  = DateFormatter()
        formatter.dateFormat = "MMMM"
        self.title = formatter.string(from: calendarMenuView.manager.date())
    }
    
    func calendarDidLoadNextPage(_ calendar: JTCalendarManager!) {
        refreshTitleMonthFromCurrentCalendarPage()
    }
    
    func calendarDidLoadPreviousPage(_ calendar: JTCalendarManager!) {
        refreshTitleMonthFromCurrentCalendarPage()
    }
    
    func calendar(_ calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
        
    }
    
    func calendar(_ calendar: JTCalendarManager!, canDisplayPageWith date: Date!) -> Bool {
        return calendarManager.dateHelper.date(self.dateSelected as! Date, isEqualOrAfter: self.minDate as! Date, andEqualOrBefore: self.maxDate as! Date)
    }
    
    func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        // Today
        if calendarManager.dateHelper.date(NSDate() as Date!, isTheSameDayThan: (dayView as! JTCalendarDayView).date) {
            (dayView as! JTCalendarDayView).circleView.isHidden = false;
            (dayView as! JTCalendarDayView).circleView.backgroundColor = UIColor.blue
            (dayView as! JTCalendarDayView).dotView.backgroundColor = UIColor.white
            (dayView as! JTCalendarDayView).textLabel.textColor = UIColor.white
        }
        
        // Selected date
        else if((dateSelected != nil) && (calendarManager.dateHelper.date(NSDate() as Date!, isTheSameDayThan: (dayView as! JTCalendarDayView).date))) {
       
            (dayView as! JTCalendarDayView).circleView.isHidden = false;
            (dayView as! JTCalendarDayView).circleView.backgroundColor = UIColor.red
            (dayView as! JTCalendarDayView).dotView.backgroundColor = UIColor.white
            (dayView as! JTCalendarDayView).textLabel.textColor = UIColor.white
        }
            
            // Other month
        else if(!(calendarManager.dateHelper.date(calendarContentView.date, isTheSameMonthThan: (dayView as! JTCalendarDayView).date))) {
            
            (dayView as! JTCalendarDayView).circleView.isHidden = false;
            (dayView as!JTCalendarDayView).circleView.backgroundColor = UIColor.white
            (dayView as! JTCalendarDayView).dotView.backgroundColor = UIColor.white
            (dayView as! JTCalendarDayView).textLabel.textColor = UIColor.lightGray
        }
        
            // Another day of the current month
        else{
            (dayView as! JTCalendarDayView).circleView.isHidden = true
            (dayView as! JTCalendarDayView).dotView.backgroundColor = UIColor.red
            (dayView as! JTCalendarDayView).textLabel.textColor = UIColor.black
        }
        
        if(haveEventForDay(date: (dayView as! JTCalendarDayView).date as NSDate)){
            (dayView as! JTCalendarDayView).dotView.isHidden = false;
        }
        else{
            (dayView as! JTCalendarDayView).dotView.isHidden = true;
        }
    }
    
    func haveEventForDay(date:NSDate) -> Bool {
        let key = dateFormatter().string(from: date as Date)
        if (eventsByDate[key] != nil) && ((eventsByDate[key] as! NSArray).count > 0)  {
            return true
        }
        return false
    }
    
    
    func dateFormatter() -> DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        return df
    }
    
}

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellID")
        let calendarEvent = calendarEvents[indexPath.row]
        cell.textLabel?.text = "ChantierID: \(calendarEvent.chantierID)"
        cell.detailTextLabel?.text = "Duration: \(calendarEvent.duration!) \(calendarEvent.unit)"
        return cell
    }
    
}
