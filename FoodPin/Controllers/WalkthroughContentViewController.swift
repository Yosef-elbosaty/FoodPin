//
//  WalkthroughContentViewController.swift
//  FoodPin
//
//  Created by yosef elbosaty on 5/4/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
    
    //Outlets Declaration
    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var contentImageView: UIImageView!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var forwardButton: UIButton!
    var index = 0
    var heading = ""
    var imageFile = ""
    var content = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.currentPage = index
        
        headingLabel.text = heading
        contentImageView.image = UIImage(named: imageFile)
        contentLabel.text = content
        
        switch index {
        case 0...1 : forwardButton.setTitle("NEXT", for: .normal)
        case 2 : forwardButton.setTitle("DONE", for: .normal)
        default : break
        }
    }
    
    //MARK:- Next Button Pressed
    @IBAction func nextButtonPressed(sender: UIButton) {
    switch index {
    case 0...1 :
        let pageViewController = parent as! WalkthroughPageViewController
        pageViewController.forward(index: index)
    case 2 :
        UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
        dismiss(animated: true, completion: nil)
    default : break
    }
    }
    

  

}
