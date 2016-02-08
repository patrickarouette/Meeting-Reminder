//
//  ListDetailViewController.swift
//  BirthdayDailyReminder
//
//  Created by Patrick Arouette on 26/01/16.
//  Copyright © 2016 Patrick Arouette. All rights reserved.
//

import UIKit
protocol ReminderListDetailViewControllerDelegate: class
{
    func reminderListDetailViewControllerDidCancel(controller: ReminderListDetailViewController)
    func reminderListDetailViewController(controller: ReminderListDetailViewController, didFinishAddingReminderList reminderList:ReminderList)
    func reminderListDetailViewController(controller: ReminderListDetailViewController, didFinishEditingReminderList reminderList:ReminderList)
}

class ReminderListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate
{
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textReminderField: UITextField!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    var iconName = "Folder"
    
    weak var delegate: ReminderListDetailViewControllerDelegate?
    var reminderListToEdit: ReminderList?

    @IBAction func cancel()
    {
        delegate?.reminderListDetailViewControllerDidCancel(self)
    }

    @IBAction func done()
    {
        if let reminderList = reminderListToEdit
        {
            reminderList.name = textReminderField.text!
            reminderList.iconName = iconName
            delegate?.reminderListDetailViewController(self, didFinishEditingReminderList: reminderList)
        }
        else
        {
            let reminderList = ReminderList(name: textReminderField.text!)
            reminderList.iconName = iconName
            delegate?.reminderListDetailViewController(self, didFinishAddingReminderList: reminderList)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let reminderList = reminderListToEdit
        {
            title = "Edit ReminderList"
            textReminderField.text = reminderList.name
            
            doneBarButton.enabled = true
            
            iconName = reminderList.iconName
        }
        iconImageView.image = UIImage(named: iconName)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        textReminderField.becomeFirstResponder()
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?
    {
        if indexPath.section == 1
        {
            return indexPath
        }
        else
        {
            return nil
        }
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        doneBarButton.enabled = (newText.length > 0)
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "PickIcon"
        {
            let controller = segue.destinationViewController as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String)
    {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        navigationController?.popViewControllerAnimated(true)
    }
    

}

