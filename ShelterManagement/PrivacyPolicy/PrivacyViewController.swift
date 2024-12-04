//
//  PrivacyPolicyViewController.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 05.12.24.
//


import UIKit
import WebKit

class PrivacyViewController: UIViewController {
    private var webView: WKWebView!
    private let urlString = "https://docs.google.com/document/d/13bdQu8dT1Ako0WmckYNBfpUNWBdDpPGuWFuiV4UNvc8/mobilebasic"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: self.view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(webView)
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
