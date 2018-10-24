//
//  HelpViewController.swift
//  Weather_Hiteksha_IOSDemo
//
//  Created by Hiteksha G. Kathiriya on 24/10/18.
//  Copyright © 2018 Hiteksha G. Kathiriya. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView: UIWebView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // It will show the HTML Contents....
        if let url = Bundle.main.url(forResource: "help", withExtension: "html")
        {
            webView.loadRequest(URLRequest(url: url))
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
