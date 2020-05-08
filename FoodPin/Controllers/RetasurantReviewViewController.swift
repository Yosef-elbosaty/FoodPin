//
//  RetasurantReviewViewController.swift
//  FoodPin
//
//  Created by yosef elbosaty on 5/1/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit

class RetasurantReviewViewController: UIViewController {

    var restaurant : RestaurantMO!
    
    //Outlets Declaration
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var RestaurantImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    //MARK:- Animating ContainerView
    override func viewDidAppear(_ animated: Bool) {
//        UIView.animate(withDuration: 0.3) {
//            self.containerView.transform = CGAffineTransform.identity
//        }
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.2,
        initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
        self.containerView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        
        title = restaurant.name
        backgroundImageView.image = UIImage(data: restaurant.image!)
        RestaurantImageView.image = UIImage(data: restaurant.image!)
        
        //Blurring Background
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)

       
    
    }
    
   
    


}
