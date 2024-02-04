//
//  ContactHelper.swift
//  NeshanTask
//
//  Created by Arman Zohourian on 1/30/24.
//

import Foundation
import Contacts


class ContactHelper {
    static let shared = ContactHelper()
    
    var contacts = [CNContact]() {
        didSet {
            print("COntacts has been update")
        }
    }
    
    private init() {
        fetchContacts()
    }
    
    func fetchContacts(){
        
        let store = CNContactStore()
        let containerId = store.defaultContainerIdentifier()
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
        store.requestAccess(for: .contacts) { (granted, error) in
            guard granted else {
                print("Access to contacts denied.")
                return
            }
            let keysToFetch = [CNContactGivenNameKey as CNKeyDescriptor,
                                  CNContactFamilyNameKey as CNKeyDescriptor,
                                  CNContactPhoneNumbersKey as
                                  CNKeyDescriptor,
                                  CNContactThumbnailImageDataKey as CNKeyDescriptor,
                                  CNContactIdentifierKey as CNKeyDescriptor]

            do {
                let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
                self.contacts.append(contentsOf: contacts)
                print(self.contacts)
            }
            catch {
             print("Error")
            }
        }
    }

    func addContactToPhonebook(firstName: String, lastName: String, phoneNumber: String) {
        let store = CNContactStore()
        
        let newContact = CNMutableContact()
        newContact.givenName = firstName
        newContact.familyName = lastName
        newContact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: phoneNumber))]
        
        let saveRequest = CNSaveRequest()
        saveRequest.add(newContact, toContainerWithIdentifier: nil)
        
        do {
            try store.execute(saveRequest)
            print("Contact added successfully!")
            contacts = [CNContact]()
            fetchContacts()
        } catch {
            print("Error adding contact: \(error.localizedDescription)")
        }
    }
    
    func fetchContactWithIdentifier(_ identifier: String) -> CNContact? {
        let store = CNContactStore()
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContainerIdentifierKey, CNContactThumbnailImageDataKey]
        
        do {
            let contact = try store.unifiedContact(withIdentifier: identifier, keysToFetch: keysToFetch as [CNKeyDescriptor])
            return contact
        } catch {
            print("Error fetching contact with identifier \(identifier): \(error)")
            return nil
        }
    }
    
}

