//
//  MapView.swift
//  Work Wheel
//
//  Created by Ishan Jain on 4/13/19.
//  Copyright © 2019 Food Zone. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class MapView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var workDictionary = Dictionary<String, Any>()
    
    var infoDictionary = Dictionary<String, Any>()
    
    var usersDictionary = Dictionary<String, Any>()
    var stuff = Dictionary<String,Any>()
    var locationManager = CLLocationManager()
    var center: CLLocationCoordinate2D!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveCoordinates()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
        }
        
    }
   
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        index += 1
        if index == 1 {
            let location = locations.last
            self.center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude:location!.coordinate.longitude)
            self.latitude = center.latitude
            self.longitude = center.longitude
            
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView.setRegion(region, animated: true)
        }
        
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        mapView.removeAnnotations(mapView.annotations)
        retrieveCoordinates()
        
    }
    
    
    func retrieveCoordinates() {
        let userID = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        db.collection("Work").document(userID!).getDocument { (document, error) in
            if let document = document, document.exists {
                self.workDictionary = document.data()!
                //.whereField("longitude", isLessThan: self.center.longitude+1).whereField("latitude", isGreaterThan: self.center.latitude-1).whereField("longitude", isGreaterThan: self.center.longitude-1)
                db.collection("Work").whereField("latitude", isLessThan: self.center.latitude+1).getDocuments(completion: { (snapshot, error) in
                    if(error != nil) {
                        print("THE ERROR IS: ", error!)
                    }
                    else {
                        for document in (snapshot?.documents)! {
                            let long = self.center.longitude
                            let lat = self.center.latitude
                            print("CENTER",long)
                            let long1 = (document.data()["longitude"] as? Double)
                            let lat1 = (document.data()["latitude"] as? Double)
                            print(document.data()["name"],long1)
                            print(document.data()["name"],lat1)
                            if(abs(Int(long-long1!)) < 1) {
                                if(abs(Int(lat-lat1!)) < 1) {
                                
                                    let annotation = MKPointAnnotation()
                                    annotation.title = document.data()["name"] as? String
                                    annotation.coordinate = CLLocationCoordinate2D(latitude: document.data()["latitude"] as! CLLocationDegrees, longitude: document.data()["longitude"] as! CLLocationDegrees)
                                    self.mapView.addAnnotation(annotation)
                                }
                            }
                        }
                    }
                })

            }
            if(error != nil) {
                print("error is: " + error.debugDescription)
            }
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid
        
        db.collection("users").document(userID!).getDocument { (document, error) in
            
        }
        
        performSegue(withIdentifier: "toDetails", sender: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    

}
