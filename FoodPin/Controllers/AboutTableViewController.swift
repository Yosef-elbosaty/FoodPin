//
//  AboutTableViewController.swift
//  FoodPin
//
//  Created by yosef elbosaty on 5/4/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {

    
    var sectionTitles = ["Leave Feedback", "Follow Us"]
    var sectionContent = [["Rate us on App Store", "Tell us your feedback"],
    ["Twitter", "Facebook", "LinkedIn"]]
    var links = ["https://twitter.com/yosefelbosaty", "https://www.facebook.com/yosef.elbosaty.7", "https://www.linkedin.com/in/yosef-elbosaty-a31589183/"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)

    }

    //MARK:- TableView Data Source Methods:
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sectionContent[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:
    IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
        return cell
    }

    //MARK:- TableView Delegate Methods:
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0 :
            if indexPath.row == 0{
                if let url = URL(string: links[0]){
                UIApplication.shared.open(url)
                }
            }else if indexPath.row == 1{
              let destination = storyboard?.instantiateViewController(withIdentifier: "webView")
                navigationController?.pushViewController(destination!, animated: true)
                destination?.hidesBottomBarWhenPushed = true
                
            }
        case 1 :
            if let url = URL(string: links[indexPath.row]){
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true, completion: nil)
            }
            
        default : break
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
