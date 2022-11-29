//
//  DetailViewController.swift
//  WhiteHouse Petitions
//
//  Created by GGS-BKS on 12/10/22.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let detailItem = detailItem else {return}
        let html = """
        <html>
        <head>
        <meta name = "viewport" content="width=device-width, initial-scale=1">
        <style>
            .a
        {
            font-size: 150%;
         background-color: black;
        color: white;
          font-family:"Times new roman" ;
        }
        </style>
        </head>
        <body class="a">
        <b><h3><font face = "Algerian" color="white">\(detailItem.title)</font></h3></b><hr color = "red">
        
        \(detailItem.body)
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
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
