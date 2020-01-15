//
//  ViewController.swift
//  Assignment1_C0749456
//
//  Created by Megha Mahna on 2020-01-14.
//  Copyright © 2020 meghamahna. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
   
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    var temp = 0
    var locationManager = CLLocationManager()
    var destinationCoordinate: CLLocationCoordinate2D!
    var annotation: MKPointAnnotation?
    var mode_of_transport = 0;
   // var newCoordinate: CLLocationCoordinate2D?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        let dtgr = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        dtgr.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(dtgr)
        mapView.showsUserLocation = true
        // Do any additional setup after loading the view.
        //mapRoute()
    }
    
    @objc func doubleTap(gestureRecognizer: UITapGestureRecognizer){
            
//            for annotation in mapView.annotations{
//                mapView.removeAnnotation(annotation)
//            }
//
//            for overlay in mapView.overlays{
//                mapView.removeOverlay(overlay)
//            }
                
                let touchPoint = gestureRecognizer.location(in: mapView)
                let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                mapView.addAnnotation(annotation)
                destinationCoordinate = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                
           
            
            
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
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
           
            directionRequest.transportType = .automobile
            mode_of_transport = 0
        case 1:

            directionRequest.transportType = .walking
            mode_of_transport = 1
        default:
            
            directionRequest.transportType = .automobile
            mode_of_transport = 0
            
        }
        
    
        
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
    
   
    
    
    @IBAction func findMyWay(_ sender: UIButton) {
        
        
        mapRoute(destinationCoordinate: destinationCoordinate)
        
    }
    
    
    

    @IBAction func zoomOut(_ sender: UIButton) {
        
        let value = mapView.userLocation.coordinate
        let region = MKCoordinateRegion(center: value, latitudinalMeters: 850000*2, longitudinalMeters: 850000*2)
        mapView.setRegion(region, animated: true)
        
    }
}
extension ViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            
            return nil
        }
            
        else
        {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
            pin.animatesDrop = true
            pin.tintColor = .red
            return pin
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if mode_of_transport == 0{
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
            return renderer
        }
        
        else{
            
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.red
            renderer.lineWidth = 4.0
            return renderer
        }
        return MKOverlayRenderer()
    }
}



