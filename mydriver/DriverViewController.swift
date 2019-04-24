//
//  DriverViewController.swift
//  mydriver
//
//  Created by Osama Soliman on 4/23/19.
//  Copyright © 2019 Osama Soliman. All rights reserved.
//

import UIKit
import MapKit
import Parse
class DriverViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var map: MKMapView!
    var requestLocation : CLLocationCoordinate2D!
    var requestUsername : String = ""
    
    @IBAction func RequestAcceptedButton(_ sender: Any) {
        let query = PFQuery(className:"riderRequest")
        query.whereKey("username", equalTo: requestUsername)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                
                print(error.localizedDescription)
            } else if let objects = objects {
                
               
                
                for object in objects {
                    object["driverResponded"] = PFUser.current()?.username
                    object.saveInBackground()
                    let requestcllocation = CLLocation(latitude: self.requestLocation.latitude, longitude:   self.requestLocation.longitude)
                    CLGeocoder().reverseGeocodeLocation(requestcllocation, completionHandler: { (placemarks, error) in
                        if error != nil {
                            print("Reverse geocoder failed with error" + error!.localizedDescription)
                        }else if placemarks!.count > 0 {
                            let pm = placemarks![0]
                            let mkPm = MKPlacemark(placemark: pm)
                            let mapItem = MKMapItem(placemark: mkPm)
                            
                            mapItem.name = self.requestUsername
                            
                            //You could also choose: MKLaunchOptionsDirectionsModeWalking
                            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                            mapItem.openInMaps(launchOptions: launchOptions)
                            
                        } else {
                            print("Problem with the data received from geocoder")
                        }
                    })
                    
                    

                }
            }
        }
    }
    
 

    override func viewDidLoad() {
        super.viewDidLoad()

        print(requestUsername)
        print(requestLocation!)
        
        
        let region = MKCoordinateRegion(center: requestLocation, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        self.map.setRegion(region, animated: true)
        //add location pin
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(requestLocation.latitude, requestLocation.longitude);
        myAnnotation.title = requestUsername
        map.addAnnotation(myAnnotation)

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
