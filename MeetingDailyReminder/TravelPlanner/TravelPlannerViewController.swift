//
//  ViewController.swift
//  TravelPlanner
//
//  Created by Patrick Arouette on 25/01/16.
//  Copyright © 2016 Patrick Arouette. All rights reserved.
//

import UIKit

class TravelPlannerViewController: UITableViewController, ItemTravelViewControllerDelegate {

    //var travelItems: [TravelListItem]
    var reminderList: ReminderList!
    
    /*
    required init?(coder aDecoder: NSCoder)
    {
        travelItems = [TravelListItem]()
        
        super.init(coder: aDecoder)
    }
    */
    
    /*
    row0Item.textTravel = "Make Sure Days Are Available"
    row1Item.textTravel = "Buy Plane Ticket"
    row2Item.textTravel = "Prepare Visa"
    row3Item.textTravel = "Rent a hotel"
    row4Item.textTravel = "Have some cash converted"
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = reminderList.name
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return reminderList.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier( "TravelListItem", forIndexPath: indexPath)
        let travelItem = reminderList.items[indexPath.row]

        configureTextForCell(cell, withChecklistItem: travelItem)
        configureCheckmarkForCell(cell, withChecklistItem: travelItem)

        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let cell = tableView.cellForRowAtIndexPath(indexPath)
        {
            let travelItem = reminderList.items[indexPath.row]
            travelItem.toggleChecked()
            configureCheckmarkForCell(cell, withChecklistItem: travelItem)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item: TravelListItem)
    {
        let label = cell.viewWithTag(27) as! UILabel
        if item.checkedTravel
        {
            label.text = "✔"
            label.textColor = view.tintColor
        } else
        {
            label.text = ""
        }
        //saveTravelListItems()
    }
    
    func configureTextForCell(cell: UITableViewCell, withChecklistItem item: TravelListItem)
    {
        let label = cell.viewWithTag(28) as! UILabel
        
        label.text = "\(item.itemID): \(item.textTravel)"

        label.textColor = view.tintColor
        
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        reminderList.items.removeAtIndex(indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        //saveTravelListItems()
    }
    
    //For protocol
    func addTravelItemViewControllerDidCancel(controller: ItemTravelDetailViewController)
    {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addTravelItemViewController(controller: ItemTravelDetailViewController, didFinishAddingItem item: TravelListItem)
    {
        let newRowIndex = reminderList.items.count
        reminderList.items.append(item)
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        dismissViewControllerAnimated(true, completion: nil)
        //saveTravelListItems()
    }
    
    func addItemViewController(controller: ItemTravelDetailViewController, didFinishEditingItem item: TravelListItem)
    {
        if let index = reminderList.items.indexOf(item)
        {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath)
            {
                configureTextForCell(cell, withChecklistItem: item)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
        //saveTravelListItems()
    }
    
    
    //We define the protocol
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "AddTravelItem"
        {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemTravelDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditTravelItem"
        {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemTravelDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            {
                controller.itemTravelToEdit = reminderList.items[indexPath.row]
            }
        }
    }
    /*
    func documentsDirectory() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String
    {
        return (documentsDirectory() as NSString).stringByAppendingPathComponent("ReminderLists.plist")
    }
    
    func saveTravelListItems()
    {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(travelItems, forKey: "TravelListItems")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadChecklistItems()
    {
        let path = dataFilePath()
        if (NSFileManager.defaultManager().fileExistsAtPath(path))
        {
            if let data = NSData(contentsOfFile: path)
            {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                travelItems = unarchiver.decodeObjectForKey("TravelListItems") as! [TravelListItem]
                unarchiver.finishDecoding()
            }
        } else
        {
                let row0Item = TravelListItem()
                row0Item.textTravel = "Make Sure Days Are Available"
                row0Item.checkedTravel = false
                travelItems.append(row0Item)
                
                let row1Item = TravelListItem()
                row1Item.textTravel = "Buy Plane Ticket"
                row1Item.checkedTravel = true
                travelItems.append(row1Item)
                
                let row2Item = TravelListItem()
                row2Item.textTravel = "Prepare Visa"
                row2Item.checkedTravel = true
                travelItems.append(row2Item)
                
                let row3Item = TravelListItem()
                row3Item.textTravel = "Rent a hotel"
                row3Item.checkedTravel = false
                travelItems.append(row3Item)
                
                let row4Item = TravelListItem()
                row4Item.textTravel = "Check Shuttle Timetable"
                row4Item.checkedTravel = false
                travelItems.append(row4Item)
                
                let row5Item = TravelListItem()
                row5Item.textTravel = "Subway Price Comparision"
                row5Item.checkedTravel = false
                travelItems.append(row5Item)

                let row6Item = TravelListItem()
                row6Item.textTravel = "Buy iOS Audio Sentences App"
                row6Item.checkedTravel = false
                travelItems.append(row6Item)
        
        }
    }
    */
}

