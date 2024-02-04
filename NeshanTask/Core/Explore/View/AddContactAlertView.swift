//
//  AddContactAlertView.swift
//  NeshanTask
//
//  Created by Arman Zohourian on 1/31/24.
//

import Foundation
import UIKit

class AlertHandler {
    static func presentAddContactAlert(on viewController: UIViewController, completion: @escaping (String, String, String) -> Void) {
        let alert = UIAlertController(title: "Add New Contact", message: "", preferredStyle: .alert)

        alert.addTextField { name in
            name.placeholder = "Name"
        }

        alert.addTextField { phone in
            phone.placeholder = "Mobile"
        }

        alert.addTextField { company in
            company.placeholder = "Company"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            let name = alert.textFields![0].text ?? "No name"
            let lastName = alert.textFields![1].text ?? "No name"
            let phoneNumber = alert.textFields![2].text ?? "No number"

            completion(name, lastName, phoneNumber)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            print("Cancel")
        }

        alert.addAction(addAction)
        alert.addAction(cancelAction)

        viewController.present(alert, animated: true, completion: nil)
    }
}

