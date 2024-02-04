//
//  TripsViewController.swift
//  NeshanTask
//
//  Created by Arman Zohourian on 1/22/24.
//

import UIKit

class TripsViewController: UIViewController {
    
    var viewModel: SavedTripsViewModel = SavedTripsViewModel()
    var editViewController: EditTripViewController?
    var tripsTableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Saved Trips"
        setupTableView()
        view.addSubview(tripsTableView)
        setupViews()
        viewModel.fetchTrips()
        
    }
}

extension TripsViewController {
    
    private func setupViews() {
        NSLayoutConstraint.activate([
        tripsTableView.topAnchor.constraint(equalTo: view.topAnchor),
        tripsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tripsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tripsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    }
    
    private func setupTableView() {
        tripsTableView.register(TripTableViewCell.self, forCellReuseIdentifier: TripTableViewCell.identifier)
        tripsTableView.dataSource = self
        tripsTableView.delegate = self
    }
    
}

extension TripsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tripsTableView.dequeueReusableCell(withIdentifier: TripTableViewCell.identifier, for: indexPath) as! TripTableViewCell
        let trip = viewModel.trips[indexPath.row]
        cell.setValues(with: trip)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTrip = viewModel.trips[indexPath.row]
        viewModel.selectedTrip = selectedTrip
        let editViewController = EditTripViewController(viewModel: viewModel, selectedTrip: selectedTrip) { [weak self] in
            self?.viewModel.updateTrip()
        }
        editViewController.editTripDelegate = self
        presentBottomSheet(viewController: editViewController)
    }
    
    
}

extension TripsViewController: TripViewModelDelegate {
    func didFetchContacts() {
        self.editViewController?.contactCollection.reloadData()
    }
    
    func didFailedFetchingTrips() {
        
    }
    
    func didUpdateTrip() {
        self.tripsTableView.reloadData()
    }
    
    func didFetchTrips() {
        self.tripsTableView.reloadData()
    }
    
    func didTapAddContact() {
        // Get the topmost visible view controller
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController?.topViewController() {
            AlertHandler.presentAddContactAlert(on: topViewController) { name, lastName, phoneNumber in
                self.viewModel.addContactToPhonebook(firstName: name, lastName: lastName, phoneNumber: phoneNumber)
            }
        }
    }
    
}
