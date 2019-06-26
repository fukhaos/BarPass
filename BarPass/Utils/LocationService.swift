//
//  UserLocationManager.swift
//  BarPass
//
//  Created by Bruno Lopes on 26/06/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: NSError)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    class var sharedInstance: LocationService {
        struct Static {
            static var instance: LocationService? = LocationService()
        }

        return Static.instance!
    }
    
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // you have 2 choice
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
        locationManager.distanceFilter = 200 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.delegate = self
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        // singleton for get last location
        self.lastLocation = location
        
        // use for real time update location
        updateLocation(currentLocation: location)
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse && status != .notDetermined {
            let Alerta = UIAlertController(title: "Permissao de localizacao", message: "Necessario permissao para acesso a" +
                " sua localizacao!! por favor habilite", preferredStyle: UIAlertController.Style.alert)
            
            let acoesConfiguracoes = UIAlertAction(title: "Abrir configuracoes", style: UIAlertAction.Style.default,
                                                   handler: { (alertaConfiguracoes) in
                                                    
                                                    if let configuracoes = NSURL(string: UIApplication.openSettingsURLString) {
                                                        UIApplication.shared.open(configuracoes as URL)
                                                    }
            })
            
            let cancelar = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.destructive, handler: nil)
            
            Alerta.addAction(acoesConfiguracoes)
            Alerta.addAction(cancelar)
            
            UIApplication.shared.topViewController?.present(Alerta, animated: true, completion: nil)
        }
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        // do on error
        updateLocationDidFailWithError(error: error)
    }
    
    // Private function
    private func updateLocation(currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: NSError) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error: error)
    }
    
    func checkAuthorization() {
        if CLLocationManager.authorizationStatus().rawValue == 2 {
            let Alerta = UIAlertController(title: "Permissão de localização", message: "Necessário permissão para acesso a" +
                " sua localizacao!! por favor habilite.", preferredStyle: UIAlertController.Style.alert)
            
            let acoesConfiguracoes = UIAlertAction(title: "Abrir configuracoes", style: UIAlertAction.Style.default,
                                                   handler: { (alertaConfiguracoes) in
                                                    
                                                    if let configuracoes = NSURL(string: UIApplication.openSettingsURLString) {
                                                        UIApplication.shared.open(configuracoes as URL)
                                                    }
            })
            
            let cancelar = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.destructive, handler: nil)
            
            Alerta.addAction(acoesConfiguracoes)
            Alerta.addAction(cancelar)
            
            UIApplication.shared.topViewController?.present(Alerta, animated: true, completion: nil)
        }
    }
}
