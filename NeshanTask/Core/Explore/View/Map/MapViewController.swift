//
//  MapViewController.swift
//  NeshanTask
//
//  Created by Arman Zohourian on 1/28/24.
//

import Foundation
import UIKit
import MapKit


protocol MapDelegate: AnyObject {
    func didClosedSheet()
}
//MARK: Properties
class MapViewController: UIViewController {
    
    var viewModel: ExploreViewModel
    private lazy var mapView : MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    private let locationManager = CLLocationManager()
    private var existingAnnotation: MKPointAnnotation?
    private lazy var testLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Test Label"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    let regionInMeters: Double = 10000
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupGesture()
        checkLocationServices()
    }
    
    init(viewModel: ExploreViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("Map deinitied")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: Methods
private extension MapViewController {
    func setupLayout() {
        
        //Map view
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
    }
    func setupGesture() {
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecogniser)
    }
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            
        }
    }
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            break
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            locationManager.requestWhenInUseAuthorization()
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationManager.requestWhenInUseAuthorization()
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    @objc func handleLongPress(_ gestureRecognizer : UIGestureRecognizer){
        
        if gestureRecognizer.state != .began { return }
        
        // Remove the existing annotation (if any)
        if let existingAnnotation = existingAnnotation {
            mapView.removeAnnotation(existingAnnotation)
        }
        // Get the touch point and convert it to a map coordinate
        let touchPoint = gestureRecognizer.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)

        let latitude = Double(touchMapCoordinate.latitude)
        let longtitude = Double(touchMapCoordinate.longitude)
        
        
        // Create a new annotation and set its coordinate
        let newAnnotation = MKPointAnnotation()
        existingAnnotation = newAnnotation
        newAnnotation.coordinate = touchMapCoordinate
        mapView.addAnnotation(newAnnotation)

        // Add the new annotation to the map
        

        // Optionally, center the map on the dropped pin
        mapView.setCenter(touchMapCoordinate, animated: true)
        
        viewModel.getLocationDetails(latitude: latitude, longtitude: longtitude)
        
    }
}
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
    }
}
    


