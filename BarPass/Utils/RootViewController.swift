//
//  RootViewController.swift
//  BarPass
//
//  Created by Bruno Lopes on 05/06/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces

class RootViewController: UIViewController {
    
    
    // MARK: - Outlets
    
    var userLocation: CLLocationCoordinate2D?
    static let locationManager = CLLocationManager()
    var completion: ((NSError?, CLLocationCoordinate2D?) -> Void)?
    var placesClient: GMSPlacesClient!
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RootViewController.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        RootViewController.locationManager.startUpdatingLocation()
        RootViewController.locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
    }
    
    func getLocation(completion: @escaping (_ error: NSError?, _ location: CLLocationCoordinate2D?) -> Void) {
        //        RootViewController.locationManager.requestWhenInUseAuthorization()
        //        RootViewController.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            if self.completion == nil {
                self.completion = completion
                RootViewController.locationManager.startUpdatingLocation()
            }
            completion(nil, userLocation)  // LEO: Fix Nearby Drivers
        } else {
            completion(NSError(domain: "Serviço de localização está desativado.", code: 400, userInfo: nil), nil)
        }
    }
    
    static func stopUpdatingLocation() {
        RootViewController.locationManager.stopUpdatingLocation()
    }
}


// MARK: - CLL Location manager delegate

extension RootViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            //            print("location updated")
            userLocation = location.coordinate
            
            self.completion?(nil, location.coordinate)
            self.completion = nil
        } else {
            print("Error updating location")
            self.completion?(NSError(domain: "Você não autorizou o acesso à sua localização.", code: 400, userInfo: nil), nil)
            self.completion = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.completion?(NSError(domain: "Você não autorizou o acesso à sua localização.", code: 400, userInfo: nil), nil)
        self.completion = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            self.completion?(NSError(domain: "Você não autorizou o acesso à sua localização.", code: 400, userInfo: nil), nil)
            self.completion = nil
        }
    }
}

