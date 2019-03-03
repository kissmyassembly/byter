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
    
    @IBAction func centerButton(_ sender: Any)
    {
        centerViewOnUserLocation()
    }
   
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    
    var db: Firestore!
    var docRef: DocumentReference!
    let collectionName = "users-test"
    
    var currentDictionary: [String: Any] = [:]
    var currentUser: User?
    var otherUsers: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupFirebase()
        
        //additionalSafeAreaInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: mapView.bounds.height, right: 0.0)
        checkLocationServices()
        
        // TEST CODE: set direct path to only user document on Firebase
        //docRef = Firestore.firestore().document("/users/SMyYX2fVBOA8sEX8kol6")
        
        // TEST CODE: hard code user data
//        currentUser = User.init(dictionary: self.tempUserDictionary())
//        let dataToSave: [String: Any] = currentUser!.asDictionary()
//        currentUser = User.init(dictionary: self.tempUserDictionary())
        
        
        // TEST CODE: save current user's data to firebase
//        docRef.setData(dataToSave) { (error) in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//            } else {
//                print("Data successfully saved!")
//            }
//        }
        
        // TEST CODE: fetch current user's data from firebase
//        docRef.getDocument { (docSnapshot, error) in
//            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
//            let myData = docSnapshot.data()
//            let spotify_id = myData!["spotify_id"] as? String ?? ""
//            let latitude = myData!["latitude"] as? Double ?? 0
//            let longitude = myData!["longitude"] as? Double ?? 0
//            let artists = myData!["artists"] as? String ?? ""
//            let song = myData!["song"] as? String ?? ""
//
//            print("Current User Data")
//            print("-----------------")
//            print(spotify_id)
//            print(latitude)
//            print(longitude)
//            print(artists)
//            print(song)
//        }
        
        // get all data from Firebase
        //self.getData()
        
        // update current user's information
//        self.rewriteCurrentUser()
    }
    
//    func tempUserDictionary() -> [String: Any] {
//        let identifier = UIDevice.current.identifierForVendor?.uuidString
//        print("output is: ", identifier! as String)
//
//        return [
//            //"spotify_id": "111",
//            "latitude": 37.783333, // TODO: put current user latitude
//            "longitude": -122.416668, // TODO: put current user latitude
//            //"artists": "New Artist",
//            //"song": "New Song"
//            "device_id": identifier ?? ""
//        ]
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
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        print(document.data())
                    }
                }
        }
    }
    
    func rewriteCurrentUser() {
        let identifier = UIDevice.current.identifierForVendor?.uuidString
        let idString = identifier! as String
        
        // TEST CODE: save current user's data to firebase
        //        docRef.setData(dataToSave) { (error) in
        //            if let error = error {
        //                print("Error: \(error.localizedDescription)")
        //            } else {
        //                print("Data successfully saved!")
        //            }
        //        }
        
        db.collection(collectionName)
            .whereField("device_id", isEqualTo: idString)
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    print("Current user successfully retrieved!")
                    
                    // replace user data locally
                    //let newDictionary = self.tempUserDictionary()
                    self.currentDictionary["device_id"] = idString
                    print(self.currentDictionary)
                    let newUserData =  User.init(dictionary: self.currentDictionary)
                    self.currentUser = newUserData
                    
                    // replace user data on Firebase
                    let dID = querySnapshot!.documents.first?.documentID
                    self.docRef = Firestore.firestore().document(
                        self.collectionName + "/" + dID!)
                    
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
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            
            // update current user's information
            self.rewriteCurrentUser()
            
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
        
        print(center.latitude)
        print(center.longitude)
        print()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        checkLocationAuthorization()
    }
}
