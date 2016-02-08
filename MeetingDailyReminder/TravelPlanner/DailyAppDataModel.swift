//
//  DailyAppDataModel.swift
//  BirthdayDailyReminder
//
//  Created by Patrick Arouette on 27/01/16.
//  Copyright © 2016 Patrick Arouette. All rights reserved.
//

import Foundation

class DailyAppDataModel
{
    var reminderLists = [ReminderList]()
    
    var indexOfSelectedReminderList: Int
    {
        get
        {
            return NSUserDefaults.standardUserDefaults().integerForKey("ReminderListIndex")
        }
        
        set
        {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ReminderListIndex")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    //Init
    init()
    {
        registerDefaults()
        loadReminderLists()
        handleFirstTime()
    }
    
    func registerDefaults()
    {
        
        let dictionaryReminder = [ "ReminderListIndex": -1 ,
                                    "FirstRunningTime": true,
                                    "ReminderListItemID": 0 ]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionaryReminder)
        
    }
    
    func handleFirstTime()
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstRunningTime")
        if firstTime
        {
        
            var list = ReminderList(name: "Birthday")
            reminderLists.append(list)
            
            list = ReminderList(name: "Name Day")
            reminderLists.append(list)
            
            list = ReminderList(name: "Urgent task")
            reminderLists.append(list)
            
            list = ReminderList(name: "Gift Idea")
            reminderLists.append(list)
            
            list = ReminderList(name: "Thinking for future")
            reminderLists.append(list)
            
            list = ReminderList(name: "Shopping list")
            reminderLists.append(list)
            
            list = ReminderList(name: "Inside fridge")
            reminderLists.append(list)
            
            
            for list in reminderLists
            {
                let travelList = TravelListItem()
                
                travelList.textTravel = "Item 1 for \(list.name)"
                list.items.append(travelList)
                
                let travelList2 = TravelListItem()
                travelList2.textTravel = "Item 2 for \(list.name)"
                list.items.append(travelList2)
                
                let travelList3 = TravelListItem()
                travelList3.textTravel = "Item 3 for \(list.name)"
                list.items.append(travelList3)
                
                let travelList4 = TravelListItem()
                travelList4.textTravel = "Item 4 for \(list.name)"
                list.items.append(travelList4)
                
                let travelList5 = TravelListItem()
                travelList5.textTravel = "Item 5 for \(list.name)"
                list.items.append(travelList5)
            }
            
            userDefaults.setBool(false, forKey: "FirstRunningTime")
            userDefaults.synchronize()
        }
    }
    
    //Save And Load System
    func documentsDirectory() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String
    {
        let lPath = (documentsDirectory() as NSString).stringByAppendingPathComponent("ReminderMyLists.plist")
        return lPath
    }
    
    func saveReminderLists()
    {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(reminderLists, forKey: "ReminderMyLists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadReminderLists()
    {
        let path = dataFilePath()
        let fileExists = NSFileManager.defaultManager().fileExistsAtPath(path)
        if (fileExists == true)
        {
            if let data = NSData(contentsOfFile: path)
            {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                reminderLists = unarchiver.decodeObjectForKey("ReminderMyLists") as! [ReminderList]
                unarchiver.finishDecoding()
            }
        }
        sortChecklists()
    }
    
    func sortChecklists()
    {
        reminderLists.sortInPlace(
            {
                checklist1, checklist2 in return
                checklist1.name.localizedStandardCompare(checklist2.name) == .OrderedAscending
            })
    }
    
    class func nextChecklistItemID() -> Int
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let itemID = userDefaults.integerForKey("ReminderListItemID")
        userDefaults.setInteger(itemID + 1, forKey: "ReminderListItemID")
        userDefaults.synchronize()
        return itemID
    }
    
    
}