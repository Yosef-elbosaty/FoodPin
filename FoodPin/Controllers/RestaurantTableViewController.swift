//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by yosef elbosaty on 4/30/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit
import CoreData

    
    

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
   
    var restaurants : [RestaurantMO] = []
    var searchResults : [RestaurantMO] = []
    var fetchResultsController : NSFetchedResultsController<RestaurantMO>!
    
    //Outlets Declaration
    var searchController : UISearchController!
   
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnSwipe = true
    }
    //Instantiate WalkthroughController
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
        return
        }
        
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? WalkthroughPageViewController {
            present(pageViewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Fetching Data From CoreData
        let fetchRequest : NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let context = appDelegate.persistentContainer.viewContext
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            do {
            try fetchResultsController.performFetch()
            if let fetchedObjects = fetchResultsController.fetchedObjects {
            restaurants = fetchedObjects
            }
            } catch {
            print(error)
            }}
        
        //Adding Search Bar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = false
        
        //Customize Search Bar Appearance
        searchController.searchBar.placeholder = "Search restaurants..."
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor(red: 218.0/255.0, green: 100.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        searchController.searchBar.searchTextField.backgroundColor = UIColor.white
      
    }

    //MARK:- Tableview DataSource Methods:

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive{
            return searchResults.count
        }else{
            return restaurants.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RestaurantTableViewCell

        let restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
        cell.nameLabel?.text = restaurant.name
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        cell.thumbnailImageView?.image = UIImage(data: restaurant.image!)
        cell.thumbnailImageView.layer.cornerRadius = 32.5
        cell.thumbnailImageView.clipsToBounds = true
        cell.thumbnailImageView.contentMode = .scaleToFill
        cell.accessoryType = restaurant.isVisited ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
        let context = appDelegate.persistentContainer.viewContext
        let restaurantToDelete = self.fetchResultsController.object(at: indexPath)
        context.delete(restaurantToDelete)
        appDelegate.saveContext()
            }
        handler(true)
        }
        
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, view, handler) in
            if let imageToShare = UIImage(data: self.restaurants[indexPath.row].image!){
                let defaultText = "Just Checking At " + self.restaurants[indexPath.row].name!
                let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
            
            
            handler(true)
        }
        
       let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction,shareAction])
        return swipeConfiguration
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
        return false
        } else {
        return true
    }
    }
    
    //MARK:- TableView delegate Methods:
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // go to detail view controller
        let destination = storyboard?.instantiateViewController(withIdentifier: "detailView") as! RestaurantDetailViewController
        navigationController?.pushViewController(destination, animated: true)
        //Pass Data To Details View
        destination.restaurant = (searchController.isActive) ?
        searchResults[indexPath.row] : restaurants[indexPath.row]
        destination.hidesBottomBarWhenPushed = true
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- Go To New Restaurant View
    @IBAction func gotoNewRestaurant(_ sender: Any) {
      
        performSegue(withIdentifier: "newRestaurant", sender: self)
    }
    
    //MARK:- Back To Home
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {}
    
    //MARK:- FetchResultsControllerDelegate Methods:
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
            case .insert:
                if let newIndexPath = newIndexPath{
                    tableView.insertRows(at: [newIndexPath], with: .fade)
                }
            case .delete:
                if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
                }
            case .update:
                if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
                }
            default:
                tableView.reloadData()
                }
        if let fetchedObjects = controller.fetchedObjects{
            restaurants = fetchedObjects as! [RestaurantMO]
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
            
    }
    
    //MARK:- Filtering Search Results
    func filterContent(for searchText : String){
        searchResults = restaurants.filter({ (restaurant) -> Bool in
            if let name = restaurant.name{
                let isMatch = name.localizedCaseInsensitiveContains(searchText)
            return isMatch
            }
            else if let location = restaurant.location{
                let isMatch = location.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            
            return false
            })
    }
    
    //MARK:- Updating Search Results
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
}
  

