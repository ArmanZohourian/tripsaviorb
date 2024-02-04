//
//  TripsViewModel.swift
//  NeshanTask
//
//  Created by Arman Zohourian on 1/30/24.
//

import Foundation
import CoreData
import Contacts

protocol TripViewModelDelegate: AnyObject {
    func didFetchTrips()
    func didFailedFetchingTrips()
    func didUpdateTrip()
    func didFetchContacts()
    func didTapAddContact()
}

class SavedTripsViewModel {
    
    weak var delegate : TripViewModelDelegate?
    
    var trips: [TripEntity] = [] 
    var selectedTrip: TripEntity?
    var contacts = [CNContact]()
    var selectedContacts = [CNContact]() {
        didSet {
            print("Added or remove contact \(selectedContacts.count)")
        }
    }
    let tripDataService = TripDataService.shared
    let contactDataService = ContactHelper.shared
    
    init() {
        self.contacts = contactDataService.contacts
    }
    
    func fetchTrips() {
        trips = tripDataService.fetchTrips()
        self.delegate?.didFetchTrips()
    }
    
    func fetchContacts() {
        contacts = contactDataService.contacts
        self.delegate?.didFetchContacts()
    }
    
    func fetchCnContacts(with identifier: String) -> CNContact? {
        let selectedCnContact = contactDataService.fetchContactWithIdentifier(identifier)
        if let existingContact = selectedCnContact {
            selectedContacts.append(existingContact)
        }
        return selectedCnContact
    }
    
    func appendContact(with contact: CNContact) {
        if let selectedContact = selectedContacts.firstIndex(of: contact) {
            selectedContacts.remove(at: selectedContact)
        } else {
            selectedContacts.append(contact)
        }
    }
    
    func isSelectedContact(with identifier: String) -> Bool {
        if let index = selectedContacts.firstIndex(where: { $0.identifier == identifier }) {
            selectedContacts.remove(at: index)
            return false
        } else {
            if let selectedCnContact = contactDataService.fetchContactWithIdentifier(identifier) {
                selectedContacts.append(selectedCnContact)
                return true
            }
            return false
        }
    }
    
    func addContactToPhonebook(firstName: String, lastName: String, phoneNumber: String) {
        contactDataService.addContactToPhonebook(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        fetchContacts()
        self.delegate?.didFetchContacts()
    }
    
    
    func updateTrip() {
        guard let existingTrip = selectedTrip else { return }
        tripDataService.updateTripContacts(trip: existingTrip, newContacts: selectedContacts)
        self.delegate?.didUpdateTrip()
        
    }
}
