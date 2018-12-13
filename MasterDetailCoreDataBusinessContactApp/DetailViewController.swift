// Project:     Business Contact Manager
// Author:      Diczhazy
// Date:        12/7/18
// File:        DetailViewController.swift
// Description: Detail View Controller

import UIKit
import CoreData

class DetailViewController: UIViewController, NSFetchedResultsControllerDelegate
{
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    
    // Update Detail View with Business Contact info
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem
        {
            if let label = nameTextField
            {
                label.text = detail.name!.description
            }
            if let label = emailTextField
            {
                label.text = detail.email!.description
            }
            if let label = phoneTextField
            {
                label.text = detail.phone!.description
            }
            if let label = streetTextField
            {
                label.text = detail.street!.description
            }
            if let label = cityTextField
            {
                label.text = detail.city!.description
            }
            if let label = stateTextField
            {
                label.text = detail.state!.description
            }
            if let label = zipTextField
            {
                label.text = detail.zip!.description
            }
            if let label = companyTextField
            {
                label.text = detail.company!.description
            }
        }
    }
    
    @IBAction func UpdateBtn(_ sender: UIButton)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Business")
        //fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur1")
        fetchRequest.predicate = NSPredicate(format: "name = %@", (nameTextField.text)!)
        
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue(emailTextField.text, forKey: "email")
            objectUpdate.setValue(phoneTextField.text, forKey: "phone")
            objectUpdate.setValue(streetTextField.text, forKey: "street")
            objectUpdate.setValue(cityTextField.text, forKey: "city")
            objectUpdate.setValue(stateTextField.text, forKey: "state")
            objectUpdate.setValue(zipTextField.text, forKey: "zip")
            objectUpdate.setValue(companyTextField.text, forKey: "company")
            
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
        
    }
    
     // Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    // Sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Call configureView function, based on detailItem event
    var detailItem: Business? {
        didSet {
            // Update the view.
            configureView()
        }
    }
}

