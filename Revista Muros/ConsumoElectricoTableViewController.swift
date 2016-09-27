//
//  ConsumoElectricoTableViewController.swift
//  Revista Muros
//
//  Created by Gerardo Israel Monteverde on 2/13/16.
//  Copyright © 2016 Gerardo Israel Monteverde. All rights reserved.
//

import UIKit
import CloudKit

class ConsumoElectricoTableViewController: UITableViewController {
    
    var consumos = [CKRecord]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "electricity.png")
        imageView.image = image
        navigationItem.titleView = imageView
        
        loadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadData(){
        consumos = [CKRecord]()
        let privateData = CKContainer.defaultContainer().privateCloudDatabase
        let query = CKQuery(recordType: "ConsumoElectrico", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        privateData.performQuery(query, inZoneWithID: nil) { (results: [CKRecord]?, error: NSError?) -> Void in
            if let consumos = results {
                self.consumos = consumos
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return consumos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("consumoElectricoCell", forIndexPath: indexPath)

        if consumos.count == 0 {
            return cell
        }
        
        let consumo = consumos[indexPath.row]
        
        if let consumoContenido = consumo["newConsumo"] as? String {
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormat.stringFromDate(consumo.creationDate!)
            
            cell.textLabel?.text = consumoContenido
            cell.detailTextLabel?.text = dateString
            
            cell.imageView?.image = UIImage(named: "electricity.png")
            
        }
        
        // Configure the cell...

        return cell
    }

    
    @IBAction func sendConsumo(sender: AnyObject) {
        let Alert = UIAlertController(title: "Nuevo consumo", message: "Escribe el nuevo consumo", preferredStyle: UIAlertControllerStyle.Alert)
        
        Alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            textField.placeholder = "Cantidad"
        }
        
        Alert.addAction(UIAlertAction(title: "Guardar", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
            let textField = Alert.textFields!.first!
            
            
            if textField.text != "" {
                let newConsumo = CKRecord(recordType: "ConsumoElectrico")
                newConsumo["newConsumo"] = textField.text
                
                let privateData = CKContainer.defaultContainer().privateCloudDatabase
                privateData.saveRecord(newConsumo, completionHandler: { (record: CKRecord?, error: NSError?) -> Void in
                    if error == nil {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.tableView.beginUpdates()
                            self.consumos.insert(newConsumo, atIndex: 0)
                            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
                            self.tableView.endUpdates()
                        })
                    }
                    else{
                        print(error)
                    }
                })
                
            }
            
        }))
        
        Alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(Alert, animated: true, completion: nil)
        
        
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
