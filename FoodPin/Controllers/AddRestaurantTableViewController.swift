//
//  AddRestaurantTableViewController.swift
//  FoodPin
//
//  Created by yosef elbosaty on 5/3/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit
import  CoreData

class AddRestaurantTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var restaurant : RestaurantMO!
    var isVisited = true
    //Outlets Declaration
    @IBOutlet var photoImageView : UIImageView!
    @IBOutlet var nameTextField : UITextField!
    @IBOutlet var locationTextField : UITextField!
    @IBOutlet var typeTextField : UITextField!
    @IBOutlet var phoneTextField : UITextField!
    @IBOutlet var yesButton : UIButton!
    @IBOutlet var noButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
       
  
    }

    // MARK:- Table View Delegate Methods:
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.isEditing = false
                imagePicker.sourceType = .photoLibrary
               present(imagePicker, animated: true, completion: nil)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleToFill
            photoImageView.clipsToBounds = true
            
        }
        
        //Defining Constraints
        
        let leadingConstraint = NSLayoutConstraint(item: photoImageView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: photoImageView!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
            trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: photoImageView!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: photoImageView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
            bottomConstraint.isActive = true
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Save Button Pressed
    @IBAction func saveButtonPressed(_ sender: Any) {
        if nameTextField.text == "" || locationTextField.text == "" || typeTextField.text == "" || phoneTextField.text == "" {
            let alertController = UIAlertController(title: "AlertTitle".localized, message: "Alertmsg".localized, preferredStyle: .alert)
            let action = UIAlertAction(title: "AlertAction".localized, style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }else{
            //Saving Data Using CoreData
            if let appDelegate = (UIApplication.shared.delegate) as? AppDelegate{
                restaurant = RestaurantMO(context: appDelegate.persistentContainer.viewContext)
                restaurant.name = nameTextField.text
                restaurant.type = typeTextField.text
                restaurant.location = locationTextField.text
                restaurant.phoneNumber = phoneTextField.text
                restaurant.isVisited = isVisited
                if let restaurantImage = photoImageView.image{
                    if let imageData = restaurantImage.pngData(){
                        restaurant.image = NSData(data: imageData) as Data
                    }
                }
                appDelegate.saveContext()
            }
            
           dismiss(animated: true, completion: nil)
        }
    
    }
            
    //MARK:- Been Here Button Tapped
    @IBAction func toggleBeenHereButton(sender: UIButton) {
        if sender == yesButton{
            isVisited = true
            yesButton.backgroundColor = UIColor.red
            noButton.backgroundColor = UIColor.lightGray
            
        }else if sender == noButton{
            isVisited = false
            noButton.backgroundColor = UIColor.red
            yesButton.backgroundColor = UIColor.lightGray
            
        }
        
    }
   
}
