//
//  PromocionesTableViewController.swift
//  Revista Muros
//
//  Created by Gerardo Israel Monteverde on 2/12/16.
//  Copyright © 2016 Gerardo Israel Monteverde. All rights reserved.
//

import UIKit
import CloudKit

class PromocionesTableViewController: UITableViewController {
    
    var promociones = [CKRecord]()
    var refresh:UIRefreshControl!
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Actualizando...")
        refresh.addTarget(self, action: "loadData", forControlEvents: .ValueChanged)
        self.tableView.addSubview(refresh)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "logo_superior.png")
        imageView.image = image
        navigationItem.titleView = imageView
        
        
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
        
        loadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadData(){
        promociones = [CKRecord]()
        
        self.actInd.startAnimating()
        
        let publicData = CKContainer.defaultContainer().publicCloudDatabase
        let query = CKQuery(recordType: "Promociones", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        publicData.performQuery(query, inZoneWithID: nil) { (results: [CKRecord]?, error: NSError?) -> Void in
            
            if let ediciones = results {
                self.promociones = ediciones
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                    self.refresh.endRefreshing()
                    self.actInd.stopAnimating()
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
        return promociones.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:PromocionesCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("promocionesCell", forIndexPath: indexPath) as! PromocionesCellTableViewCell

        
        if promociones.count == 0 {
            return cell
        }
        
        let promocion = promociones[indexPath.row]
        
        if let empresa = promocion["Empresa"] as? String{

            cell.Empresa.text = empresa
            cell.Descripcion.text = promocion["Descripcion"] as? String
            
            
            if (promocion["Cover"] != nil){
                let imageAsset: CKAsset = promocion["Cover"] as! CKAsset
                cell.Cover.image = UIImage(contentsOfFile: imageAsset.fileURL.path!)
            }
            else{
                
            }
        }
        

        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        // 1
        let Direcciones = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Direcciones" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 2
            
            let promocion = self.promociones[indexPath.row]
            
            let ubicacion = promocion["Ubicacion"] as? CLLocation
            let latitude = ubicacion?.coordinate.latitude
            let longitude = ubicacion?.coordinate.longitude
            
            let url = NSURL(string: "http://maps.apple.com/maps?daddr=\(latitude!),\(longitude!)")
            UIApplication.sharedApplication().openURL(url!)
            
        })
        
        // 1
        let call = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Llamar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 2
            let phoneCall = self.promociones[indexPath.row]
            let number = phoneCall["Telefono"] as? String
            if let url = NSURL(string: "tel://\(number!)") {
                print(url)
                UIApplication.sharedApplication().openURL(url)
            }
        })
        
        // 1
        let website = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Website" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 2
            let website = self.promociones[indexPath.row]
            let websiteURL = website["Website"] as? String
            let url = NSURL(string: websiteURL!)
            UIApplication.sharedApplication().openURL(url!)
        })
        
        Direcciones.backgroundColor = UIColor.blackColor()
        call.backgroundColor = UIColor.grayColor()
        website.backgroundColor = UIColor.lightGrayColor()
        
        return [Direcciones, call, website]
        
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
