// Project:     Business Contact Manager
// Author:      Diczhazy
// Date:        12/7/18
// File:        MasterViewController.swift
// Description: Master View Controller

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate
{
    
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    // variable for test data
    var count:Int = 0
    
    // Called after the controller's view is loaded into memory. Edit and Add (+) buttons added to the Navigation Bar.
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
      // Notifies the view controller that its view is about to be added to a view hierarchy. This is always collapsed on an iPhone.
    override func viewWillAppear(_ animated: Bool)
    {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
     // Sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Adds Business Contact to Table View, saves in Core Data
    @objc
    func insertNewObject(_ sender: Any)
    {
        // create an Alert with a textFields
        let alertController = UIAlertController(title: "Add Contact",
                                                message: "",
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        // add the textField to the Alert. Create a closure to handle the configuration
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="Name"
            textField.keyboardType=UIKeyboardType.emailAddress
        })
        
        // add the textField to the Alert. Create a closure to handle the configuration
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="Email"
            textField.keyboardType=UIKeyboardType.emailAddress
        })
        
        // add the textField to the Alert. Create a closure to handle the configuration
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="Phone"
            textField.keyboardType=UIKeyboardType.emailAddress
        })
        
        // add the textField to the Alert. Create a closure to handle the configuration
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="Street"
            textField.keyboardType=UIKeyboardType.emailAddress
        })
        
        // add the textField to the Alert. Create a closure to handle the configuration
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="City"
            textField.keyboardType=UIKeyboardType.emailAddress
        })
        
        // add the textField to the Alert. Create a closure to handle the configuration
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="State"
            textField.keyboardType=UIKeyboardType.emailAddress
        })
        
        // add the textField to the Alert. Create a closure to handle the configuration
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="Zip"
            textField.keyboardType=UIKeyboardType.emailAddress
        })
        
        // add the textField to the Alert. Create a closure to handle the configuration
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="Company"
            textField.keyboardType=UIKeyboardType.emailAddress
        })
        
        // create a default action for the Alert
        // Must cast an element in the array from anyObject to UITextFiled pg. 322
        let defaultAction = UIAlertAction(
            title: "Create",
            style: UIAlertActionStyle.default,
            handler: {(alertAction: UIAlertAction!) in
                // get the input from the alert controller
                let context = self.fetchedResultsController.managedObjectContext
                let newBusiness = Business(context: context)
                
                newBusiness.name = (alertController.textFields![0]).text!
                newBusiness.email = (alertController.textFields![1]).text!
                newBusiness.phone = (alertController.textFields![2]).text!
                newBusiness.street = (alertController.textFields![3]).text!
                newBusiness.city = (alertController.textFields![4]).text!
                newBusiness.state = (alertController.textFields![5]).text!
                newBusiness.zip = (alertController.textFields![6]).text!
                newBusiness.company = (alertController.textFields![7]).text!
                
                // Save the context.
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                
                // reload the data into the TableView
                self.tableView.reloadData()
        })
        // cancel button
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.cancel,
            handler:nil)
        
        // add the actions to the Alert
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        // generate test data
        gernerateTestData(alertController: alertController)

        // display the Alert
        present(alertController, animated: true, completion: nil)
    }
    
    // Creates test data in Alert Controller
    func gernerateTestData(alertController:UIAlertController)
    {
        // increment count
        count += 1
        // get the textfields and assign test data
        (alertController.textFields![0]).text = "name\(count)"
        (alertController.textFields![1]).text = "email\(count)@mail.com"
        (alertController.textFields![2]).text = "phone\(count)"
        (alertController.textFields![3]).text = "street\(count)"
        (alertController.textFields![4]).text = "city\(count)"
        (alertController.textFields![5]).text = "oh"
        (alertController.textFields![6]).text = "44060"
        (alertController.textFields![7]).text = "company\(count)"
    }

    // MARK: - Segues
    
    // Notifies the view controller that a segue is about to be performed.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showDetail"
        {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    // Asks the data source to return the number of sections in the table
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    // Asks the data source to return the number of rows in a given section of a table view.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
     // Asks the data source for a cell to insert in a particular location of the table view.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let event = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withEvent: event)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
     // Asks the data source to verify that the given row is editable.
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            // create an Alert with a textFields
            let alertController = UIAlertController(title: "Update Contact",
                                                    message: "",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            // add the textField to the Alert. Create a closure to handle the configuration
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder="Name"
                textField.keyboardType=UIKeyboardType.emailAddress
                textField.isUserInteractionEnabled = false
            })
            
            // add the textField to the Alert. Create a closure to handle the configuration
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder="Email"
                textField.keyboardType=UIKeyboardType.emailAddress
            })
            
            // add the textField to the Alert. Create a closure to handle the configuration
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder="Phone"
                textField.keyboardType=UIKeyboardType.emailAddress
            })
            
            // add the textField to the Alert. Create a closure to handle the configuration
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder="Street"
                textField.keyboardType=UIKeyboardType.emailAddress
            })
            
            // add the textField to the Alert. Create a closure to handle the configuration
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder="City"
                textField.keyboardType=UIKeyboardType.emailAddress
            })
            
            // add the textField to the Alert. Create a closure to handle the configuration
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder="State"
                textField.keyboardType=UIKeyboardType.emailAddress
            })
            
            // add the textField to the Alert. Create a closure to handle the configuration
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder="Zip"
                textField.keyboardType=UIKeyboardType.emailAddress
            })
            
            // add the textField to the Alert. Create a closure to handle the configuration
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder="Company"
                textField.keyboardType=UIKeyboardType.emailAddress
            })
            
            // create a default action for the Alert
            // Must cast an element in the array from anyObject to UITextFiled pg. 322
            let defaultAction = UIAlertAction(
                title: "Update",
                style: UIAlertActionStyle.default,
                handler: {(alertAction: UIAlertAction!) in
                    let object = self.fetchedResultsController.object(at: indexPath)
                    
                    // get the input from the alert controller
                    let email: String = (alertController.textFields![1]).text!
                    let phone: String = (alertController.textFields![2]).text!
                    let street: String = (alertController.textFields![3]).text!
                    let city: String = (alertController.textFields![4]).text!
                    let state: String = (alertController.textFields![5]).text!
                    let zip: String = (alertController.textFields![6]).text!
                    let company: String = (alertController.textFields![7]).text!
                    
                    object.setValue(email, forKey: "email")
                    object.setValue(phone, forKey: "phone")
                    object.setValue(street, forKey: "street")
                    object.setValue(city, forKey: "city")
                    object.setValue(state, forKey: "state")
                    object.setValue(zip, forKey: "zip")
                    object.setValue(company, forKey: "company")
                    
                    let context = self.fetchedResultsController.managedObjectContext
                    do {
                        try context.save()
                    } catch {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                    
                    // reload the data into the TableView
                    self.tableView.reloadData()
            })
            // cancel button
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: UIAlertActionStyle.cancel,
                handler:nil)
            
            // add the actions to the Alert
            alertController.addAction(defaultAction)
            alertController.addAction(cancelAction)
            
            // get business entity by name.
            // returns a single ContactBusiness object
            let object = self.fetchedResultsController.object(at: indexPath)
            
            (alertController.textFields![0]).text = object.name
            (alertController.textFields![1]).text = object.email
            (alertController.textFields![2]).text = object.phone
            (alertController.textFields![3]).text = object.street
            (alertController.textFields![4]).text = object.city
            (alertController.textFields![5]).text = object.state
            (alertController.textFields![6]).text = object.zip
            (alertController.textFields![7]).text = object.company
            
            // display the Alert
            self.present(alertController, animated: true, completion: nil)
        }
        editAction.backgroundColor = .blue
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            let context = self.fetchedResultsController.managedObjectContext
            context.delete(self.fetchedResultsController.object(at: indexPath))
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        deleteAction.backgroundColor = .red
        
        return [editAction,deleteAction]
    }
    
    // Add name to cell label
    func configureCell(_ cell: UITableViewCell, withEvent event: Business)
    {
        cell.textLabel!.text = event.name?.description
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Business>
    {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Business> = Business.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<Business>? = nil
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Business)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Business)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
     // In the simplest, most efficient, case, reload the table view.
     tableView.reloadData()
     }
     */
    
}

