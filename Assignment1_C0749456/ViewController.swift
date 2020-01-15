//
//  ViewController.swift
//  Assignment1_C0749456
//
//  Created by Megha Mahna on 2020-01-14.
//  Copyright © 2020 meghamahna. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var temp = 0
    
    var locationManager = CLLocationManager()
    var user_latitude: CLLocationDegrees = 0.0
    var user_longitude: CLLocationDegrees = 0.0
    var new_latitude: CLLocationDegrees = 0.0
    var new_longitude: CLLocationDegrees = 0.0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        let dtgr = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        dtgr.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(dtgr)
        mapView.showsUserLocation = true
        // Do any additional setup after loading the view.
        //mapRoute()
    }
    
    @objc func doubleTap(gestureRecognizer: UITapGestureRecognizer){
            
            if temp == 0{
                
                let touchPoint = gestureRecognizer.location(in: mapView)
                let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                new_latitude = annotation.coordinate.latitude
                new_longitude = annotation.coordinate.longitude
                mapRoute(destinationCoordinate: annotation.coordinate)
                temp = 1
                
                
            }
            
            
        }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        let userLocation: CLLocation = locations[0]
//        user_latitude = userLocation.coordinate.latitude
//        user_longitude = userLocation.coordinate.longitude
//
//    }
    
    func mapRoute(destinationCoordinate: CLLocationCoordinate2D){
        
        
        
        mapView.delegate = self
        
      
        let sourceLocation = CLLocationCoordinate2D(latitude: 43.65, longitude: -79.38)
        let destinationLocation = CLLocationCoordinate2D(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)
        
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
       
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
       
        let sourceAnnotation = MKPointAnnotation()
        
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
   
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        
        let directions = MKDirections(request: directionRequest)
        
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
    
        return renderer
    }


}

