//
//  WebViewController.swift
//  RecipesCollectionApp
//
//  Created by jekaterina.livcane on 11/09/2020.
//  Copyright © 2020 jekaterina.livcane. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    
    var passedValue = ""
    
    override func loadView() {
            self.title = "WebView"
            
            webView = WKWebView()
            webView.navigationDelegate = self
            view = webView
        }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let url = URL(string: passedValue)
            webView.load(URLRequest(url:url!))
            webView.allowsBackForwardNavigationGestures = true
        }
        

        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */

    }
