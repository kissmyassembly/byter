//
//  ViewController.swift
//  byter
//
//  Created by Gouri Jamakhandi on 3/2/19.
//  Copyright © 2019 Gouri Jamakhandi. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func centerButton(_ sender: Any)
    {
        centerViewOnUserLocation()
    }
   
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //additionalSafeAreaInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: mapView.bounds.height, right: 0.0)
        checkLocationServices()
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
        //guard let location = locations.last else { return }
        //let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        //let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        //mapView.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        checkLocationAuthorization()
    }
}
