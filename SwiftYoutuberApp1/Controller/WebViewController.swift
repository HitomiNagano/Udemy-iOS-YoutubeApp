//
//  WebViewController.swift
//  SwiftYoutuberApp1
//
//  Created by Hitomi Nagano on 2021/04/14.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 50)
        view.addSubview(webView)
        
        if UserDefaults.standard.object(forKey: "url") != nil {
            let strUrl = UserDefaults.standard.object(forKey: "url")
            let url = URL(string: strUrl as! String)
            let reqest = URLRequest(url: url!)
            webView.load(reqest)
        }
    }
    
}
