//
//  WalkthroughPageViewController.swift
//  FoodPin
//
//  Created by yosef elbosaty on 5/4/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var pageHeadings = ["Personalize", "Locate", "Discover"]
    var pageImages = ["foodpin-intro-1", "foodpin-intro-2", "foodpin-intro-3"]
    var pageContent = ["Pin your favorite restaurants and create your own food guide", "Search and locate your favourite restaurant on Maps", "Find restaurants pinned by your friends and other foodies around the world"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
       // Create the first walkthrough screen
       if let startingViewController = contentViewController(at: 0) {
       setViewControllers([startingViewController], direction: .forward,
       animated: true, completion: nil)
       }
        
    }
    
    func contentViewController(at index: Int) -> WalkthroughContentViewController?
    {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        if let pageContentViewController =
            storyboard?.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.content = pageContent[index]
            pageContentViewController.index = index
            return pageContentViewController
        }
        return nil
    }

    //MARK:- Page View Controller DataSource Methods:
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController) -> UIViewController? {
    var index = (viewController as! WalkthroughContentViewController).index
    index += 1
    return contentViewController(at: index)
    }
    
    func forward(index: Int) {
        if let nextViewController = contentViewController(at: index + 1) {
        setViewControllers([nextViewController], direction: .forward, animated:
        true, completion: nil)
        }
    }
    
    
    


}
