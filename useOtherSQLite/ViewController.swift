//
//  ViewController.swift
//  useOtherSQLite
//
//  Created by www on 16/9/23.
//  Copyright © 2016年 www. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let db = RootViewController()
    
    @IBOutlet weak var img: UIImageView!
    @IBAction func one(sender: AnyObject) {
        db.create()
        
        
    }
    @IBAction func two(sender: AnyObject) {
        let test = [["12","3"],["12","3","12","3"],["12","3"]]
        let a = 1122
        db.nameAry = String(a)
        db.saveAry = test
        
        db.nameImage = "dz"
        db.saveImage = UIImage(named: "dz.jpg")
        db.saveData()
    }
    @IBAction func three(sender: AnyObject) {
        db.nameAry = "1122"
        db.nameImage = "dz"
        db.readData()
        if db.readImage == nil {
            print("nil")
        }
        self.img.image = db.readImage
        let test:[[String]] = db.readAry as! [[String]]
        print(test)
        
        //self.view.setNeedsDisplay()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

