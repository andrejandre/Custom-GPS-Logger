//
//  ViewController.swift
//  GPS
//
//  Created by Andre Unsal on 2/18/19.
//  Copyright © 2019 Andre Unsal. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate
{
    // IBOutlet declarations
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startStop: UIButton!
    @IBOutlet weak var export: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var xCoordLabel: UILabel!
    @IBOutlet weak var yCoordLabel: UILabel!
    
    // Variable declarations:
    var locationManager: CLLocationManager!
    var i = 0.0 // global var for time logging
    var earthRadius = 6371000.00 // meters
    // Variables for CSV:
    var currentTime = [Double]()
    var userLatitude = [Double]()
    var userLongitude = [Double]()
    var userX = [Double]()
    var userY = [Double]()
    var newLine = [String]()
    
    // View did load, handles basic map instantiation
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.delegate = self as? MKMapViewDelegate
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 1)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
    }

    // Instantiates and initializes CLLocationManager's location updates
    func determineMyCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
    }
    
    // Maps user location with respect to time to a variety of variables
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.00125, repeats: true)
        {
            (timer) in
            self.i += timer.timeInterval
            print("Time (s): \(self.i)")
            print("Latitude: \(userLocation.coordinate.latitude)")
            print("Longitude: \(userLocation.coordinate.longitude)")
            print("X (M): \(self.earthRadius * cos(userLocation.coordinate.latitude) * cos(userLocation.coordinate.longitude))")
            print("Y (M): \(self.earthRadius * cos(userLocation.coordinate.latitude) * sin(userLocation.coordinate.longitude))")
            self.timeLabel.text = ("\(self.i)")
            self.latitudeLabel.text = "\(userLocation.coordinate.latitude)"
            self.longitudeLabel.text = "\(userLocation.coordinate.longitude)"
            self.xCoordLabel.text = ("\(self.earthRadius * cos(userLocation.coordinate.latitude) * cos(userLocation.coordinate.longitude))")
            self.yCoordLabel.text = ("\(self.earthRadius * cos(userLocation.coordinate.latitude) * sin(userLocation.coordinate.longitude))")
            self.currentTime.append(self.i)
            self.userLatitude.append(Double(userLocation.coordinate.latitude))
            self.userLongitude.append(Double(userLocation.coordinate.longitude))
            self.userX.append(Double(self.earthRadius * cos(userLocation.coordinate.latitude) * cos(userLocation.coordinate.longitude)))
            self.userY.append(Double(self.earthRadius * cos(userLocation.coordinate.latitude) * cos(userLocation.coordinate.longitude)))
            self.newLine.append("\(self.i), \(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude), \(self.earthRadius * cos(userLocation.coordinate.latitude) * cos(userLocation.coordinate.longitude)), \(self.earthRadius * cos(userLocation.coordinate.latitude) * sin(userLocation.coordinate.longitude))\n")
        }
        
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
    }
    

    // Error handling
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    // Start button pressed
    @IBAction func startPressed(_ sender: UIButton)
    {
        print("Start button was pressed.")
        determineMyCurrentLocation()
        startStop.isEnabled = false
        startStop.backgroundColor = UIColor.gray
        startStop.setTitle("logging...", for: UIControl.State.disabled)
        
    }
    
    // Export button pressed
    @IBAction func exportPressed(_ sender: Any)
    {
        print("Export button was pressed.")
        
        let fileName = "customGPS.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "Time (s), Latitude, Longitude, X (M), Y (M)\n"
        for line in self.newLine
        {
            //print(line)
            csvText.append(contentsOf: line)
        }
        
        //csvText.append(contentsOf: self.newLine)
        do
        {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            let vc = UIActivityViewController(activityItems: [path!], applicationActivities: [])
            vc.excludedActivityTypes = [
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo,
                UIActivity.ActivityType.postToTwitter,
                UIActivity.ActivityType.postToFacebook,
                UIActivity.ActivityType.openInIBooks
            ]
            present(vc, animated: true, completion: nil)
        }
        catch
        {
            print("Failed to create file")
            print("\(error)")
        }
        
        self.i = 0.0
        locationManager.stopUpdatingLocation()
        startStop.isEnabled = true
        startStop.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        startStop.setTitle("START", for: UIControl.State.normal)
        self.i = -0.24681
        
    }
}


