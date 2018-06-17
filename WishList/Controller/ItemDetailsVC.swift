//
//  ItemDetailsVC.swift
//  WishList
//
//  Created by ElectroZone on 2018-02-09.
//  Copyright © 2018 Wassim Mouhajer. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var storePicker: UIPickerView!
    
    //Initialize the array of Store objects
    var stores = [Store]()
    
    //Initialize item
    var itemToEdit: Item?
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        
        storePicker.delegate = self
        storePicker.dataSource = self
        titleField.delegate = self
        priceField.delegate = self
        detailsField.delegate = self
        titleField.returnKeyType = .done
        priceField.returnKeyType = .done
        detailsField.returnKeyType = .done
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        //Add stores
        let store1 = Store(context: context)
        store1.name = "Amazon"
        let store2 = Store(context: context)
        store2.name = "Android"
        let store3 = Store(context: context)
        store3.name = "Apple"
        let store4 = Store(context: context)
        store4.name = "Best Buy"
        let store5 = Store(context: context)
        store5.name = "Microsoft"
        let store6 = Store(context: context)
        store6.name = "Google"
        //Save stores
        ad.saveContext()
        //Load
        getStores()
        
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Update when selected
    }
    
    func getStores() {
        //Fetch Store
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            let error = error as NSError
            print(error)
        }
    }
   
    @IBAction func savePressed(_ sender: UIButton) {
        var item: Item!
        let picture = Image(context: context)
        
        picture.image = thumbImage.image
        
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        
        item.toImage = picture
        
        //Make sure it's not empty
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        
        
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        ad.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    func loadItemData() {
        //Edit
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumbImage.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                } while (index < stores.count)
            }
            
        }
    }
    
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        //Remove item
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        _ = navigationController?.popViewController(animated: true )
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImage.image = img
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
