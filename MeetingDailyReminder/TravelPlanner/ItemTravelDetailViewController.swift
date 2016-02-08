//
//  AddTravelItemViewController.swift
//  TravelPlanner
//
//  Created by Patrick Arouette on 25/01/16.
//  Copyright © 2016 Patrick Arouette. All rights reserved.
//

import Foundation
import UIKit

protocol ItemTravelViewControllerDelegate: class
{
    func addTravelItemViewControllerDidCancel(controller: ItemTravelDetailViewController)
    func addTravelItemViewController(controller: ItemTravelDetailViewController, didFinishAddingItem item: TravelListItem)
    func addItemViewController(controller: ItemTravelDetailViewController, didFinishEditingItem item: TravelListItem)
}

class ItemTravelDetailViewController: UITableViewController, UITextFieldDelegate
{
    weak var delegate: ItemTravelViewControllerDelegate?
    
    
    @IBOutlet weak var textFieldTravel: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var dueDate = NSDate()
    var datePickerVisible = false
    
    var itemTravelToEdit: TravelListItem?
    
    @IBAction func cancel()
    {
        delegate?.addTravelItemViewControllerDidCancel(self)
    }
    
    @IBAction func done()
    {
        if let item = itemTravelToEdit
        {
            item.textTravel = textFieldTravel.text!
            
            item.shouldRemind = shouldRemindSwitch.on
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.addItemViewController(self, didFinishEditingItem: item)
        } else
        {
            let travelItem = TravelListItem()
            travelItem.textTravel = textFieldTravel.text!
            travelItem.checkedTravel = false
                
            travelItem.shouldRemind = shouldRemindSwitch.on
            travelItem.dueDate = dueDate
            travelItem.scheduleNotification()
            delegate?.addTravelItemViewController(self, didFinishAddingItem: travelItem)
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        doneBarButton.enabled = false
        textFieldTravel.becomeFirstResponder()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        let oldText: NSString = textFieldTravel.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        doneBarButton.enabled = (newText.length > 0)
        return true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let item = itemTravelToEdit
        {
            title = "Edit Item"
            textFieldTravel.text = item.textTravel
            doneBarButton.enabled = true
            
            shouldRemindSwitch.on = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDueDateLabel()
    }
    
    func updateDueDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        dueDateLabel.text = formatter.stringFromDate(dueDate)
    }
    
    
    func showDatePicker()
    {
        datePickerVisible = true
        
        let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
        let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
        
        
        if let dateCell = tableView.cellForRowAtIndexPath(indexPathDateRow)
        {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        
        
        tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
        tableView.endUpdates()
        
        datePicker.setDate(dueDate, animated: false)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.section == 1 && indexPath.row == 2
        {
            return datePickerCell
        } else
        {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 1 && datePickerVisible
        {
            return 3
        }
        else
        {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.section == 1 && indexPath.row == 2
        {
            return 217
        }
        else
        {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        textFieldTravel.resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1
        {
            if !datePickerVisible
            {
                showDatePicker()
            }
            else
            {
                hideDatePicker()
            }
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?
    {
        if indexPath.section == 1 && indexPath.row == 1
        {
            return indexPath
        }
            else
        {
                return nil
        }
    }
    
    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int
    {
        if indexPath.section == 1 && indexPath.row == 2
        {
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)

    }
    
    @IBAction func dateChanged(datePicker: UIDatePicker)
    {
        dueDate = datePicker.date
        doneBarButton.enabled = true
        updateDueDateLabel()
    }
    
    func hideDatePicker()
    {
        if datePickerVisible
        {
            datePickerVisible = false
            let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
            let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
            if let cell = tableView.cellForRowAtIndexPath(indexPathDateRow)
            {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
    
            tableView.endUpdates()
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        hideDatePicker()
    }
    
    @IBAction func shouldRemindToggled(switchControl: UISwitch)
    {
            textFieldTravel.resignFirstResponder()
            if switchControl.on
            {
                let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert , .Sound], categories: nil)
                UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
            }
    }
    
    
    
}