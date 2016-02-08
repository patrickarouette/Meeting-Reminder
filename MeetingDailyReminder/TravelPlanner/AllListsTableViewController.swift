//
//  AllListsTableViewController.swift
//  BirthdayDailyReminder
//
//  Created by Patrick Arouette on 26/01/16.
//  Copyright © 2016 Patrick Arouette. All rights reserved.
//

import UIKit

class AllListsTableViewController: UITableViewController, ReminderListDetailViewControllerDelegate, UINavigationControllerDelegate
{

    //var reminderLists: [ReminderList]
    
    /*required init?(coder aDecoder: NSCoder)
    {
        reminderLists = [ReminderList]()
        super.init(coder: aDecoder)
        loadReminderLists()
    }*/
    
    var dailyAppDataModel: DailyAppDataModel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        let index = dailyAppDataModel.indexOfSelectedReminderList
        if (index >= 0 && index<dailyAppDataModel.reminderLists.count)
        {
            let reminderList = dailyAppDataModel.reminderLists[index]
            performSegueWithIdentifier("ShowReminderList", sender: reminderList)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dailyAppDataModel.reminderLists.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = cellForTableView(tableView)
        
        let reminderList = dailyAppDataModel.reminderLists[indexPath.row]
        cell.textLabel!.text = reminderList.name
        cell.accessoryType = .DetailDisclosureButton
        
        let vCount = reminderList.countUncheckedItems()
        if (reminderList.items.count == 0)
        {
            cell.detailTextLabel!.text = "No reminder inside"
        }
        else if (vCount>0)
        {
            cell.detailTextLabel!.text = "\(vCount) Remaining"
        }
        else
        {
            cell.detailTextLabel!.text = "Everything is completed"
        }
        
        cell.imageView!.image = UIImage(named: reminderList.iconName)
        return cell
    }
    
    func cellForTableView(tableView: UITableView) -> UITableViewCell
    {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        {
            return cell
        }
        else
        {
            return UITableViewCell(style: /*.Default*/.Subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let reminderList = dailyAppDataModel.reminderLists[indexPath.row]
        dailyAppDataModel.indexOfSelectedReminderList = indexPath.row
        performSegueWithIdentifier("ShowReminderList", sender: reminderList)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "ShowReminderList"
        {
            let controller = segue.destinationViewController as! TravelPlannerViewController
            controller.reminderList = sender as! ReminderList
        }
        else if segue.identifier == "AddReminderList"
        {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ReminderListDetailViewController
            controller.delegate = self
            controller.reminderListToEdit = nil
        }
    }
    
    func reminderListDetailViewControllerDidCancel(controller: ReminderListDetailViewController)
    {
                dismissViewControllerAnimated(true, completion: nil)
    }
    
    func reminderListDetailViewController(controller: ReminderListDetailViewController, didFinishAddingReminderList reminderList:ReminderList)
    {
        /*
        let newRowIndex = dailyAppDataModel.reminderLists.count
        dailyAppDataModel.reminderLists.append(reminderList)
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        dismissViewControllerAnimated(true, completion: nil)
        */
        ///
        dailyAppDataModel.reminderLists.append(reminderList)
        dailyAppDataModel.sortChecklists()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func reminderListDetailViewController(controller: ReminderListDetailViewController, didFinishEditingReminderList reminderList:ReminderList)
    {
        /*
        if let index = dailyAppDataModel.reminderLists.indexOf(reminderList)
        {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath)
            {
                cell.textLabel!.text = reminderList.name
            }
        }
        */
        dailyAppDataModel.sortChecklists()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        dailyAppDataModel.reminderLists.removeAtIndex(indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath)
    {
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ReminderListDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ReminderListDetailViewController
        controller.delegate = self
        let reminderList = dailyAppDataModel.reminderLists[indexPath.row]
        controller.reminderListToEdit = reminderList
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool)
    {
        if (viewController === self)
        {
            dailyAppDataModel.indexOfSelectedReminderList = -1
        }
    }
}
