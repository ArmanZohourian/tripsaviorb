//
//  ContactCollectionViewCell.swift
//  NeshanTask
//
//  Created by Arman Zohourian on 1/26/24.
//

import UIKit
import Contacts

class ContactCollectionViewCell: UICollectionViewCell {
    static let identifier = "contactcell"
    var contactImage = UIImageView()
    var contactName : UILabel = {
       var label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupImageConstraints()
        setupLableConstraints()
        configureImageView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        addSubview(contactImage)
        addSubview(contactName)

    }
    
    private func configureImageView() {
        contactImage.layer.cornerRadius = 10
        contactImage.clipsToBounds = true
    }
    
    private func setupImageConstraints() {
        contactImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contactImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            contactImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            contactImage.heightAnchor.constraint(equalToConstant: 30),
            contactImage.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func setupLableConstraints() {
        contactName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contactName.topAnchor.constraint(equalTo: contactImage.bottomAnchor, constant: 10),
            contactName.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setContact(contact: CNContact) {
        if let imageData = contact.thumbnailImageData {
            contactImage.image = UIImage(data: imageData)
        } else {
            contactImage.image = UIImage(systemName: "person.fill")
        }
        contactName.text = contact.familyName
    }
}
