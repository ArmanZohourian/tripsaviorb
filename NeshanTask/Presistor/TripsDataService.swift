//
//  TripsDataService.swift
//  NeshanTask
//
//  Created by Arman Zohourian on 1/30/24.
//

import Foundation
import CoreData
import Contacts

class TripDataService {
    
    static let shared = TripDataService()
    
    let container: NSPersistentContainer
    private let containerName: String = "TripContainer"
    private let entityName: String = "TripEntity"
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data , by the error : \(error)")
            }
        }
    }
    
    func save() {
        do {
            try container.viewContext.save()
            print("Location Has been saved")
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
     func fetchTrips() -> [TripEntity] {
        var trips: [TripEntity] = []

        let fetchRequest: NSFetchRequest<TripEntity> = TripEntity.fetchRequest()

        do {
            trips = try container.viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching trips from Core Data: \(error.localizedDescription)")
        }
        return trips
    }
    
    
     func addTrip(with locationDetails: LocationDetails, selectedContacts: [CNContact]) {
        // Convert selectedContacts to an array of ContactEntity
        let contactEntities = selectedContacts.map { contact -> ContactEntity in
            let contactEntity = ContactEntity(context: container.viewContext)
            contactEntity.firstName = contact.givenName
            contactEntity.phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? ""
            contactEntity.identifier = contact.identifier
            return contactEntity
        }
        
        
        let locationDetailEntity = LocationDetailEntity(context: container.viewContext)
        locationDetailEntity.status = locationDetails.status
        locationDetailEntity.neighbourhood = locationDetails.neighbourhood
        locationDetailEntity.city = locationDetails.city
        locationDetailEntity.country = locationDetails.county
        locationDetailEntity.state = locationDetails.state
        locationDetailEntity.formattedAddress = locationDetails.formattedAddress
        
        
        let newTripEntity = TripEntity(context: container.viewContext)
        newTripEntity.contacts = NSSet(array: contactEntities)
        newTripEntity.location = locationDetailEntity

        
        save()
    }
    
    func updateTripContacts(trip: TripEntity, newContacts: [CNContact]) {
        
        let contactEntities = newContacts.map { contact -> ContactEntity in
            let contactEntity = ContactEntity(context: container.viewContext)
            contactEntity.firstName = contact.givenName
            contactEntity.phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? ""
            contactEntity.identifier = contact.identifier
            return contactEntity
        }

        
        trip.contacts = NSSet(array: contactEntities)

        print("Trips has been updated successfully!")
        
        save()
    }
    
    private func applyChanges() {
        save()
    }
    
    
    
    
}
