//
//  ViewController.swift
//  Revista Muros
//
//  Created by Gerardo Israel Monteverde on 2/11/16.
//  Copyright © 2016 Gerardo Israel Monteverde. All rights reserved.
//

import UIKit
import CloudKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newEdicion = CKRecord(recordType: "Ediciones")
        newEdicion["edicion"] = "Diciembre 2015 - Enero 2016"
        
        let publicData = CKContainer.defaultContainer().publicCloudDatabase
        publicData.saveRecord(newEdicion) { (record: CKRecord?, error:NSError?) -> Void in
            print("Saved!")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

