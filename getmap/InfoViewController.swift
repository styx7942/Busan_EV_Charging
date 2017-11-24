//
//  InfoViewController.swift
//  getmap
//
//  Created by 이현호 on 2017. 11. 23..
//  Copyright © 2017년 이현호. All rights reserved.
//

import UIKit
import WebKit

class InfoViewController: UIViewController, WKUIDelegate,WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    
    //    @IBOutlet weak var infoSege: UISegmentedControl!
//    @IBAction func infoSegeBtn(_ sender: UISegmentedControl) {
//        if infoSege.selectedSegmentIndex == 0{
//            infoImg.image = UIImage(named: "1")
//        }else if infoSege.selectedSegmentIndex == 1{
//            infoImg.image = UIImage(named: "2")
//        }
//    }
//    @IBOutlet weak var infoImg: UIImageView!
//
    
    override func loadView() {
        super.loadView()
        webView = WKWebView(frame: self.view.frame)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        self.view = self.webView!
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let evHome = "http://www.ev.or.kr/mobile"
        let url = URL(string: evHome)
        let request = URLRequest(url: url!)
        webView.load(request)
        
        
        
        
        
//        infoImg.image = UIImage(named: "1")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
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
