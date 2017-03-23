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

class CalendarViewController: UIViewController, JTCalendarDelegate {
    @IBOutlet weak var calendarContentView: JTHorizontalCalendarView!
    @IBOutlet weak var calendarMenuView: JTCalendarMenuView!
    var calendarManager:JTCalendarManager!
    
    let eventsByDate:NSMutableDictionary = NSMutableDictionary()
    
    let todayDate = NSDate()
    var minDate = NSDate()
    var maxDate = NSDate()
    
    var dateSelected:NSDate?
    
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
        EVLTCalendarManager.sharedInstance.setup(controller: self)
        
        
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
            (dayView as!JTCalendarDayView).circleView.backgroundColor = UIColor.red
            (dayView as! JTCalendarDayView).dotView.backgroundColor = UIColor.white
            (dayView as! JTCalendarDayView).textLabel.textColor = UIColor.white
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
