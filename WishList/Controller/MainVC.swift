//
//  MainVC.swift
//  WishList
//
//  Created by ElectroZone on 2018-02-07.
//  Copyright © 2018 Wassim Mouhajer. All rights reserved.

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        attemptFetch()
//        generateTestData()
    }
    
    func attemptFetch() {
        //Item that we are fetching
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        //Sorting it by date
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        if segment.selectedSegmentIndex == 0 {
             fetchRequest.sortDescriptors = [dateSort]
        } else if segment.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [priceSort]
        } else if segment.selectedSegmentIndex == 2 {
            fetchRequest.sortDescriptors = [titleSort]
        }
       
        //Controller for the fetch
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.controller = controller
        //Since it could return nil take care of error
        do {
            try controller.performFetch()
        } catch {
          let error = error as NSError
            print(error)
        }
    }
    
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        attemptFetch()
        tableView.reloadData()
        
    }
    
    //Method to stard changes
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    //Method to end changes
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type){
        case .insert:
            //Add in new indexPath
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            //Remove a row from the existing indexPath
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            //Take the already existing cell and update it
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
                let sectionInfo = sections[section]
                return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objects = controller.fetchedObjects, objects.count > 0 {
            let item = objects[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func generateTestData() {
        let item = Item(context: context)
        item.title = "MacBook Pro"
        item.price = 2034343434343
        item.details = "Each MacBook Air gets a mid-range Intel Core i5, with a processing speed of 1.7 or 1.8 GHz. The 13-inch MacBook Pro has a 2.5- or 2.9-GHz chip, while the one on the 15-inch MacBook Pro is a more powerful but slower 2.3 GHz quad-core Intel Core i7"
        
        let item2 = Item(context: context)
        item2.title = "iPhone"
        item2.price = 3345
        item2.details = "The iPhone is a smartphone developed by Apple. ... The iPhone 5 and 5s had the same screen resolution as the iPhone 4. The iPhone 6, released in September 2014, provided a larger 4.7 display with 1334x750 pixels. The iPhone 6 Plus, released at the same time, came with an even larger 5.5-inch 1920x1080 pixel display."
        
        let item3 = Item(context: context)
        item3.title = "iPad"
        item3.price = 1
        item3.details = "The iPad is a tablet computer developed by Apple. ... The iPad does not include a keyboard or a trackpad, but instead has a touchscreen interface, which is used to control the device. Like the iPhone, the iPad runs Apple's iOS operating system."
     
        ad.saveContext()
    }
    
}

