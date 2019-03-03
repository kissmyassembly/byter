//
//  ViewController.swift
//  byter
//
//  Created by Gouri Jamakhandi on 3/2/19.
//  Copyright © 2019 Gouri Jamakhandi. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segcontrol: UISegmentedControl!
    @IBOutlet weak var segControlView: UIView!
    @IBAction func centerButton(_ sender: Any)
    {
        centerViewOnUserLocation()
    }
   
    @IBAction func segmentedControl(_ sender: Any) {
        if (segcontrol.selectedSegmentIndex == 0)
        {
            mapView.mapType = MKMapType.standard
        }
        else if (segcontrol.selectedSegmentIndex == 1)
        {
            mapView.mapType = MKMapType.hybridFlyover
        }
        else if (segcontrol.selectedSegmentIndex == 2)
        {
            mapView.mapType = MKMapType.satelliteFlyover
        }
        else { mapView.mapType = MKMapType.standard }
    }
    
    @IBAction func hamburgerButton(_ sender: Any) {
    }
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    var otherLocations: [MKPointAnnotation] = []
    
    var db: Firestore!
    var docRef: DocumentReference!
    let collectionName = "users-test"
    
    var currentDictionary: [String: Any] = [:]
    var currentUser: User?
    var otherUsers: [User] = []
    
    // testing
    //var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segControlView.clipsToBounds = true
        segControlView.layer.cornerRadius = 2
        segControlView.layer.masksToBounds = true
        
        segcontrol.clipsToBounds = true
        segcontrol.layer.cornerRadius = 2
        segcontrol.layer.masksToBounds = true
        
        self.setupFirebase()
        
        //additionalSafeAreaInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: mapView.bounds.height, right: 0.0)
        checkLocationServices()
        //segcontrol.selectedSegmentIndex = 0
        // FIXME: functions are called within callbacks to ensure sync
    }
    
    // test
//    func scheduledUpdate() {
//        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ViewController.updateOtherLocations), userInfo: nil, repeats: true)
//    }
    
    func setupFirebase() {
        // set up db from Firebase
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    func getData() {
        db.collection(collectionName)
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    let identifier = UIDevice.current.identifierForVendor?.uuidString
                    let idString = identifier! as String
                    var updatedUsers: [User] = []
                    
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let currentData = document.data()
                        //print(currentData)
                        if (currentData["device_id"] as! String != idString) {
                            let updatedUser = User.init(dictionary: currentData)
                            updatedUsers.append(updatedUser)
                        }
                    }
                    self.otherUsers = updatedUsers
                    self.updateOtherLocations()
                    //self.scheduledUpdate()
                }
        }
    }
    
    func rewriteUser(deviceID: String) {
        //let identifier = UIDevice.current.identifierForVendor?.uuidString
        //let idString = identifier! as String
        
        db.collection(collectionName)
            .whereField("device_id", isEqualTo: deviceID)//
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    //print("Current user successfully retrieved!")
                    
                    // replace user data locally
                    //let newDictionary = self.tempUserDictionary()
                    self.currentDictionary["device_id"] = deviceID//
                    print(self.currentDictionary)
                    let newUserData =  User.init(dictionary: self.currentDictionary)
                    self.currentUser = newUserData
                    
                    // replace user data on Firebase
                    if let dID = querySnapshot!.documents.first?.documentID {
                        self.docRef = Firestore.firestore().document(
                            self.collectionName + "/" + dID)
                    // make new user data on Firebase
                    } else {
                        self.docRef = self.db.collection(self.collectionName).addDocument(data: self.currentDictionary
                        ) { error in
                            if let error = error {
                                print("Error: \(error.localizedDescription)")
                            } else {
                                print("New document successfully created!")
                            }
                        }
                    }
                    
                    self.docRef.setData(self.currentDictionary) { (error) in
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        } else {
                            print("Data successfully saved!")
                        }
                    }
                    
                }
        }
    }
    
    // FIXME: get locations of others to update
    // CURRENT: no location update until fix
    func updateOtherLocations() {//
        // add annotations for initial view
//        if (self.otherLocations.isEmpty) {
//            for user in self.otherUsers {
//                let newAnnotation = MKPointAnnotation()
//                newAnnotation.coordinate = CLLocationCoordinate2D(latitude: user.latitude ?? 0, longitude: user.longitude ?? 0)
//                self.mapView.addAnnotation(newAnnotation)
//
//                self.otherLocations.append(newAnnotation)
//            }
        // update annotation coordinates
//        }
//        if (!self.otherLocations.isEmpty) {
//            for user in self.otherUsers {
//                for location in self.otherLocations {
//                    if (user.device_id == location.key) {
//                        var newCoordinate = CLLocationCoordinate2D()
//                        newCoordinate.latitude = (user.latitude ?? 0) + 0.001
//                        newCoordinate.longitude = (user.longitude ?? 0) + 0.001
//                        print("Update was reached!")
//                        print(newCoordinate)
//                        location.value.coordinate = newCoordinate
//                        break
//                    }
//                }
//            }
//            self.mapView.removeAnnotations(self.otherLocations)
            
//        }
        
        for user in self.otherUsers {
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = CLLocationCoordinate2D(latitude: user.latitude ?? 0, longitude: user.longitude ?? 0)
            newAnnotation.subtitle = user.artists! + " - " + user.song!
            self.mapView.addAnnotation(newAnnotation)
            
            self.otherLocations.append(newAnnotation)
        }
        
        // update other users' information
//        for user in self.otherUsers {
//            let dID = user.device_id
//            print("Loop was reached")
//            print(dID!)
//            self.rewriteUser(deviceID: dID ?? "")//
//        }
        
    }
    
    func setupLocationManager()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func checkLocationServices()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            setupLocationManager()
            checkLocationAuthorization()
        }
        else
        {
            //show alert letting user know to turn on location services
        }
    }
    
    func centerViewOnUserLocation()
    {
        if let location = locationManager.location?.coordinate
        {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    
    func checkLocationAuthorization()
    {
        let locationUnavailableAlert = UIAlertController(title: "Location Unavailable", message: "Your location is unavailable. Please check Settings > Privacy > Location Services > byter to enable location.", preferredStyle: .alert)
        locationUnavailableAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        switch CLLocationManager.authorizationStatus()
        {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            mapView.showsCompass = false
            mapView.isRotateEnabled = false
            //mapView.mapType = MKMapType.standard
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            
            // get all data from Firebase
            self.getData()
            
            //self.updateOtherLocations()
            
            break
        case .denied:
            
            self.present(locationUnavailableAlert, animated: true)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            self.present(locationUnavailableAlert, animated: true)
            break
        case .authorizedAlways:
            break
        }
    }


}



extension ViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        //mapView.setRegion(region, animated: true)
        
        // add user coordinates to currentUser
        self.currentDictionary["latitude"] = center.latitude
        self.currentDictionary["longitude"] = center.longitude
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        checkLocationAuthorization()
    }
}
