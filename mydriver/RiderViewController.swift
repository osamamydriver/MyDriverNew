//
//  RiderViewController.swift
//  mydriver
//
//  Created by Osama Soliman on 4/16/19.
//  Copyright © 2019 Osama Soliman. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation

class RiderViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var callADriverButton: UIButton!
    @IBOutlet weak var map: MKMapView!
    var locationManager:CLLocationManager!
    var latitude : CLLocationDegrees = 0
    var longitude : CLLocationDegrees = 0
    var riderRequested = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocationCoordinate2D = manager.location!.coordinate
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
            self.map.setRegion(region, animated: true)
            //add location pin
            self.map.removeAnnotations(map.annotations)
            let myAnnotation: MKPointAnnotation = MKPointAnnotation()
            myAnnotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
            myAnnotation.title = "Current location"
            map.addAnnotation(myAnnotation)
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
        print("locations = \(location.latitude) \(location.longitude)")
    }
    

    @IBAction func logoutButton(_ sender: Any) {
    }
    
    
    @IBAction func callDriver(_ sender: Any) {
        
        if riderRequested == false {
        let riderRequest = PFObject(className:"riderRequest")
        riderRequest["username"] = PFUser.current()?.username
        riderRequest["location"] = PFGeoPoint(latitude:latitude, longitude:longitude)
        
        riderRequest.saveInBackground {
            (success: Bool, error: Error?) in
            if (success) {
                
                self.callADriverButton.setTitle("Cancel Driver", for: UIControl.State.normal)
                self.riderRequested = true
                
            } else {
                let alert = UIAlertController(title: "Driver not called", message: "try again later", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        }else{
            self.riderRequested = false
            let query = PFQuery(className:"riderRequest")
            query.whereKey("username", equalTo: PFUser.current()!.username!)
            query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if let error = error {
                    
                    print(error.localizedDescription)
                } else if let objects = objects {
                    
                    print("Successfully retrieved \(objects.count) scores.")
                    
                    for object in objects {
                        object.deleteInBackground()
                    }
                            self.callADriverButton.setTitle("Call a Driver", for: UIControl.State.normal)
                }
            }
            
        }

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if( segue.identifier == "logoutRider" ){
            PFUser.logOutInBackground()
        }
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
