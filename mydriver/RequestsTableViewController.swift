//
//  RequestsTableViewController.swift
//  mydriver
//
//  Created by Osama Soliman on 4/23/19.
//  Copyright © 2019 Osama Soliman. All rights reserved.
//

import UIKit
import Parse
import MapKit

class RequestsTableViewController: UITableViewController,CLLocationManagerDelegate {
    var usernames = [String]()
    var locations = [CLLocationCoordinate2D]()
    var distances = [CLLocationDistance]()
    var locationManager:CLLocationManager!
    var latitude : CLLocationDegrees = 0
    var longitude : CLLocationDegrees = 0
    var myLocation : CLLocation!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        
        
        }
        
        
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location:CLLocationCoordinate2D = manager.location!.coordinate
            if let location = locations.last{
                self.latitude = location.coordinate.latitude
                self.longitude = location.coordinate.longitude
                self.myLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
            }
            let query = PFQuery(className:"riderRequest")
            query.whereKey("location", nearGeoPoint:PFGeoPoint(latitude:latitude, longitude:longitude))
            query.limit = 20
            query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if let error = error {
                    
                    print(error.localizedDescription)
                } else if let objects = objects {
                    self.usernames.removeAll()
                    self.locations.removeAll()
                    print("Successfully retrieved \(objects.count) scores.")
                    
                    for object in objects {
                        if let username = object["username"] as? String {
                            self.usernames.append(username)
                        }
                        if let returnedlocation = object["location"] as? PFGeoPoint{
                            
                            let requestlocation = CLLocationCoordinate2DMake(returnedlocation.latitude, returnedlocation.longitude)
                            self.locations.append(requestlocation)
                            let requestcllocation = CLLocation(latitude: requestlocation.latitude, longitude: requestlocation.longitude)
                            let drivercllocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                            let distance = drivercllocation.distance(from: requestcllocation)
                            self.distances.append(distance/1000)
                        }
                    }
                    self.tableView.reloadData()
                    print(self.locations)
                    print(self.usernames)
                    
                }
            

            print("locations = \(location.latitude) \(location.longitude)")
            
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath)
        
        let distanceDouble = Double(distances[indexPath.row])
        let rounded = Double(round(distanceDouble * 10) / 10 )

        cell.textLabel?.text = usernames[indexPath.row] + "  "+String(rounded) + " KM"

        return cell
    }
 

    
   
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if( segue.identifier == "logoutDriver" ){
            PFUser.logOutInBackground()
        }else if ( segue.identifier == "showViewRequests" ){
            
        }
    }

}
