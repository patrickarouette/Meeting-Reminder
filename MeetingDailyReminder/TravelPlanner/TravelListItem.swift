//
//  TravelListItem.swift
//  TravelPlanner
//
//  Created by Patrick Arouette on 25/01/16.
//  Copyright © 2016 Patrick Arouette. All rights reserved.
//

import Foundation
import UIKit

class TravelListItem : NSObject, NSCoding
{
    var textTravel = ""
    var checkedTravel = false
    
    var dueDate = NSDate()
    var shouldRemind = false
    var itemID: Int
    
    override init()
    {
        itemID = DailyAppDataModel.nextChecklistItemID()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        textTravel = aDecoder.decodeObjectForKey("Text") as! String
        checkedTravel = aDecoder.decodeBoolForKey("Checked")
        
        dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
        shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
        itemID = aDecoder.decodeIntegerForKey("ItemID")
        
        super.init()
    }
    
    func toggleChecked()
    {
        checkedTravel = !checkedTravel
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(textTravel, forKey: "Text")
        aCoder.encodeBool(checkedTravel, forKey: "Checked")
        
        aCoder.encodeObject(dueDate, forKey: "DueDate")
        aCoder.encodeBool(shouldRemind, forKey: "ShouldRemind")
        aCoder.encodeInteger(itemID, forKey: "ItemID")
        
    }
    
    func scheduleNotification()
    {
            
        let existingNotification = notificationForThisItem()
        if let notification = existingNotification
        {
            print("Found an existing notification \(notification)")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
            
            
        if shouldRemind && dueDate.compare(NSDate()) != .OrderedAscending
        {
            let localNotification = UILocalNotification()
            localNotification.fireDate = dueDate
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertBody = textTravel
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.userInfo = ["ItemID": itemID]
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            print("Scheduled notification \(localNotification) for itemID \(itemID)")
        }
    }
    
    func notificationForThisItem() -> UILocalNotification?
    {
        let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications!
        for notification in allNotifications
        {
            if let number = notification.userInfo?["ItemID"] as? Int
            where number == itemID
            {
                return notification
            }
        }
        return nil
    }
    
    deinit
    {
        if let notification = notificationForThisItem()
        {
            print("Removing existing notification \(notification)")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
    }
    
    
}