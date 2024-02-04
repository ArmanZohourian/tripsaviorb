//
//  ExploreViewController.swift
//  NeshanTask
//
//  Created by Arman Zohourian on 1/22/24.
//

import UIKit
import MapKit
import CoreLocation

class ExploreViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: Properties
    private let exploreViewModel = ExploreViewModel()
    private lazy var mapVC = MapViewController(viewModel: exploreViewModel)
    var bottomSheetDemo: MapBottomSheetViewController?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        retrieveLocation()
        exploreViewModel.delegate = self
    }
}

private extension ExploreViewController {
    //MARK: Methods
    func setupLayout() {
        add(mapVC)
    }
    
    func retrieveLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func saveTrip() {
        exploreViewModel.addTrip()
    }
}

//MARK: Viewmodel Delegate
extension ExploreViewController: ExploreViewModelDelegate {
    func didFetchContacts() {
//        self.bottomSheetDemo?.contactCollection.reloadData()
    }
    func didFetchLocationDetails() {
        let mapSheetViewController = MapBottomSheetViewController(viewModel: exploreViewModel) {[weak self] in
            self?.saveTrip()
        }
        mapSheetViewController.exploreDelegate = self
        mapSheetViewController.locationDetails = exploreViewModel.locationDetails
        presentBottomSheet(viewController: mapSheetViewController)
        
        //fixed deallocating the view
        //TODO: Fix bottomsheetDemo?
        mapSheetViewController.contactCollection.reloadData()
    }
    
    func didTapAddContact() {
        // Get the topmost visible view controller
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController?.topViewController() {
            AlertHandler.presentAddContactAlert(on: topViewController) { name, lastName, phoneNumber in
                self.exploreViewModel.addContactToPhonebook(firstName: name, lastName: lastName, phoneNumber: phoneNumber)
            }
        }
    }
    func didFail(error: Error) {
        print("Error happened")
    }
}
