//
//  RestaurantMapViewController.swift
//  FoodPin
//
//  Created by yosef elbosaty on 5/2/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit
import MapKit

class RestaurantMapViewController: UIViewController, MKMapViewDelegate {

    var restaurant : RestaurantMO!
    
    //Outlets Declaration
    @IBOutlet var mapView : MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "\(restaurant.name!)'s Address"
        
        //Adding Annotation To Map
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location!) { (placeMarks, error) in
            if error != nil{
                print(error!)
            }
            if let placeMarks = placeMarks{
                let placeMark = placeMarks[0]
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                if let location = placeMark.location{
                    annotation.coordinate = location.coordinate
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
        
    }
    //MARK:- Customizing Annotation View
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self){
            return nil
        }
        var annotationView : MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "myPin") as? MKPinAnnotationView
        
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
        leftIconView.image = UIImage(data: restaurant.image!)
        annotationView?.leftCalloutAccessoryView = leftIconView
        return annotationView
    }
    


}
