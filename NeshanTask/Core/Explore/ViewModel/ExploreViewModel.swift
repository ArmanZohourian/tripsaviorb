//
//  ExploreViewModel.swift
//  NeshanTask
//
//  Created by Arman Zohourian on 1/24/24.
//

import Foundation
import Contacts
import CoreData

protocol ExploreViewModelDelegate: AnyObject {
    func didFetchLocationDetails()
    func didFetchContacts()
    func didTapAddContact()
    func didFail(error: Error)
}

@MainActor
class ExploreViewModel {
    
    private var requestManager = RequestManager.shared
    private(set) var locationDetails : LocationDetails?
    let tripDataService = TripDataService.shared
    let contactHelper = ContactHelper.shared
    weak var delegate: ExploreViewModelDelegate?
    var contacts = [CNContact]()
    var selectedContacts = [CNContact]()
    var savedTrips = [Trip]()
    
    func fetchContacts() {
        contacts = contactHelper.contacts
        self.delegate?.didFetchContacts()
    } 
    
    func addContactToPhonebook(firstName: String, lastName: String, phoneNumber: String) {
        contactHelper.addContactToPhonebook(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        fetchContacts()
        self.delegate?.didFetchContacts()
    }
    
    func addTrip() {
        
        guard let location = locationDetails else { return }
        guard selectedContacts.count > 0 else { return }
        
        tripDataService.addTrip(with: location, selectedContacts: selectedContacts)
        
    }
    
    func appendContact(with contact: CNContact) {
        if let selectedContact = selectedContacts.firstIndex(of: contact) {
            selectedContacts.remove(at: selectedContact)
        } else {
            selectedContacts.append(contact)
        }
    }
    
    func isSelectedContact(with contact: CNContact) -> Bool {
        if selectedContacts.firstIndex(of: contact) != nil {
            return true
        } else {
            return false
        }
    }
    
    func getLocationDetails(latitude: Double, longtitude: Double) {
        Task {
            do {
                let result: LocationDetails = try await requestManager.perform(GetLocationDetails.getLocationDetailsWith(selectedLatitude: latitude, selectedLongtitude: longtitude))
                self.locationDetails = result
                self.delegate?.didFetchLocationDetails()
                
            } catch {
                print("Error occured")
                self.delegate?.didFail(error: error)
            }
        }
    }
    
    
}
