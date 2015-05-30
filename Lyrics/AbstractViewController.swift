//
//  AbstractViewController.swift
//  Lyrics
//
//  Created by Martin Mitrevski on 30/05/15.
//  Copyright (c) 2015 Martin Mitrevski. All rights reserved.
//

import UIKit

class AbstractViewController: UIViewController {

    var session: NSURLSession {
        get {
            return self.appDelegate().session
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    

}
