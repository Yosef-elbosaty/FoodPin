//
//  DetailsViewController.swift
//  FoodPin
//
//  Created by yosef elbosaty on 4/30/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit
import MapKit


class RestaurantDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var restaurant : RestaurantMO!
    
    // Outlets Declaration
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnSwipe = false
    navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add Tap Gesture To Map View
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableView.automaticDimension
      
        //TableView Appearence Customization
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue:
        240.0/255.0, alpha: 0.8)
        
        //tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        
        title = restaurant.name
        restaurantImageView.image = UIImage(data: restaurant.image!)
        restaurantImageView.contentMode = .scaleToFill
        
        //Add Annotation To Map
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location!) { (placeMarks, error) in
            if error != nil{
                print(error!)
            }
            if let placeMarks = placeMarks{
                let placeMark = placeMarks[0]
                let annotation = MKPointAnnotation()
            if let location = placeMark.location{
                annotation.coordinate = location.coordinate
                self.mapView.addAnnotation(annotation)
                
                let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                self.mapView.setRegion(region, animated: true)
                }
                
            }
        }
        
        
    }
    
    //MARK:- TableView DataSource Methods:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RestaurantDetailTableViewCell
        switch indexPath.row {
       case 0:
        cell.fieldLabel.text = "RestName".localized
        cell.valueLabel.text = restaurant.name
        case 1:
            cell.fieldLabel.text = "RestType".localized
        cell.valueLabel.text = restaurant.type
        case 2:
            cell.fieldLabel.text = "RestLocation".localized
        cell.valueLabel.text = restaurant.location
        case 3:
            cell.fieldLabel.text = "RestPhone".localized
        cell.valueLabel.text = restaurant.phoneNumber
        case 4:
            cell.fieldLabel.text = "RestBeenHere".localized
            cell.valueLabel.text = (restaurant.isVisited) ? "RestIsVisitedYes".localized  + " \(restaurant.rating ?? "")" : "RestIsVisitedNo".localized
        default:
        cell.fieldLabel.text = ""
        cell.valueLabel.text = ""
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    //MARK:- TableView Delegate Methods:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- Go To Restaurant Review ViewController

    @IBAction func gotoReviewController(_ sender: Any) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "review") as! RetasurantReviewViewController
        navigationController?.pushViewController(destination, animated: true)
        
        
        destination.restaurant = restaurant.self
    }
    
    //MARK:- Back To Restaurant Details ViewController
    @IBAction func close(segue : UIStoryboardSegue){
        
    }
    
    //MARK:- Change Restaurant Rating
    @IBAction func RatingButtonTapped(segue : UIStoryboardSegue){
        if let rating = segue.identifier{
            restaurant.isVisited = true
        switch rating{
        case "great": restaurant.rating = "RestReviewGreat".localized
        case "good": restaurant.rating = "RestReviewGood".localized
        case "dislike": restaurant.rating = "RestReviewDislike".localized
            default: break
            }
        }
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
        appDelegate.saveContext()
        }
        tableView.reloadData()
        
    }
    
    //MARK:- Go To Map
    @objc func showMap(){
        let destination = storyboard?.instantiateViewController(withIdentifier: "map") as! RestaurantMapViewController
        navigationController?.pushViewController(destination, animated: true)
        destination.restaurant = restaurant.self
    }
    
    
}
