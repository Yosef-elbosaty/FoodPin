//
//  WebViewController.swift
//  FoodPin
//
//  Created by yosef elbosaty on 5/5/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var webView : WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: "https://www.facebook.com/yosef.elbosaty.7"){
            let request = URLRequest(url: url)
            webView.load(request)
        }
 
        
    }
    

  

}
