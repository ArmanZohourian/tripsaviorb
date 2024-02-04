//
//  EditTripViewController.swift
//  NeshanTask
//
//  Created by Arman Zohourian on 1/30/24.
//

import UIKit
import Contacts

class EditTripViewController: BottomSheetViewController {

    var selectedTrip: TripEntity

    var viewModel: SavedTripsViewModel
    var editButtonAction:() -> ()
    weak var editTripDelegate: TripViewModelDelegate?
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Saint Louis"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var provinceLabel: UILabel = {
        let label = UILabel()
        label.text = "California"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "نشانی : "
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var addressValue: UILabel = {
        let label = UILabel()
        label.text = "Down street main ally"
        label.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.text = "مشخصات موقیعت انتخابی"
        label.font = UIFont.systemFont(ofSize: 21, weight: .heavy)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return label
    }()
    private lazy var neighbourhood: UILabel = {
        let label = UILabel()
        label.text = "تهران"
        label.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        label.textColor = .white
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return label
    }()
    private lazy var saveButton : UIButton = {
        var buttonConfig : UIButton = UIButton(type: .system)
        buttonConfig.translatesAutoresizingMaskIntoConstraints = false
        buttonConfig.setTitle("ویرایش", for: .normal)
        buttonConfig.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        buttonConfig.backgroundColor = UIColor.blue
        buttonConfig.setTitleColor(UIColor.white, for: .normal)
        buttonConfig.layer.cornerRadius = 15
        buttonConfig.clipsToBounds = true
        buttonConfig.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)
        return buttonConfig
    }()
    private lazy var locationStackView: UIStackView = {
       var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 7
        stack.alignment = .trailing
        stack.distribution = .fillEqually
        stack.heightAnchor.constraint(equalToConstant: 31).isActive
         = true
        return stack
    }()
    private lazy var addressStackView: UIStackView = {
       var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 7
        stack.alignment = .trailing
        stack.distribution = .fillEqually
        stack.distribution = .equalSpacing
        stack.heightAnchor.constraint(equalToConstant: 31).isActive
         = true
        return stack
    }()
    lazy var contactCollection = UICollectionView()
    private lazy var contentStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .trailing
        view.spacing = 16
        return view
    }()
    
    init(viewModel: SavedTripsViewModel,selectedTrip: TripEntity, saveButtonAction: @escaping () ->()) {
        self.selectedTrip = selectedTrip
        self.viewModel = viewModel
        self.editButtonAction = saveButtonAction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupView()
        setValues()
    }
}

private extension EditTripViewController {
     func setupView() {
        contentStackView.addArrangedSubview(overviewLabel)
        contentStackView.addArrangedSubview(locationStackView)
        contentStackView.addArrangedSubview(addressStackView)
        contentStackView.addArrangedSubview(contactCollection)
        contentStackView.addArrangedSubview(saveButton)
        setupArrangedSubViews()
        setupCustomContraints()
        self.setContent(content: contentStackView)
    }
    
     func setupCustomContraints() {
        NSLayoutConstraint.activate([
            contactCollection.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            contactCollection.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            
            saveButton.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
        ])

    }
    
     func setupArrangedSubViews() {
        locationStackView.addArrangedSubview(cityLabel)
        locationStackView.addArrangedSubview(provinceLabel)
        
        addressStackView.addArrangedSubview(addressValue)
        addressStackView.addArrangedSubview(addressLabel)
    }
    
    func setValues() {
        
        cityLabel.text = selectedTrip.location?.city ?? "Saint Louis"
        provinceLabel.text = selectedTrip.location?.state ?? "California"
        addressValue.text = selectedTrip.location?.formattedAddress ?? "Address"
        neighbourhood.text = selectedTrip.location?.neighbourhood ?? "Nothing to show"
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 50
        contactCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        contactCollection.dataSource = self
        contactCollection.delegate = self
        contactCollection.register(ContactCollectionViewCell.self, forCellWithReuseIdentifier: ContactCollectionViewCell.identifier)
        contactCollection.register(AddContactCollectionViewCell.self, forCellWithReuseIdentifier: AddContactCollectionViewCell.identifier)
        contactCollection.alwaysBounceHorizontal = true
        contactCollection.translatesAutoresizingMaskIntoConstraints = false
        contactCollection.bounces = true
        
        self.view.addSubview(contactCollection)
        NSLayoutConstraint.activate([
            contactCollection.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            contactCollection.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            contactCollection.heightAnchor.constraint(equalToConstant: 100)
        ])
        
    }

    @objc func didTapEdit() {
        editButtonAction()
        dismissBottomSheet()
    }
}


//MARK: Protocols
extension EditTripViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.contacts.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == viewModel.contacts.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddContactCollectionViewCell.identifier, for: indexPath) as! AddContactCollectionViewCell
            cell.tapCallback = { [weak self] in
                self?.editTripDelegate?.didTapAddContact()
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCollectionViewCell.identifier, for: indexPath) as! ContactCollectionViewCell
        let contact = viewModel.contacts[indexPath.row]
        cell.setContact(contact: contact)
        
        updateCellAppearance(cell, for: contact)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedContact = viewModel.contacts[indexPath.row]

        guard let cell = collectionView.cellForItem(at: indexPath) as? ContactCollectionViewCell else {
            return
        }

        if viewModel.isSelectedContact(with: selectedContact.identifier) {
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor.blue.cgColor
            cell.layer.cornerRadius = 10
        } else {
            cell.layer.borderWidth = 0
        }
    }
    
    private func updateCellAppearance(_ cell: ContactCollectionViewCell, for contact: CNContact) {
        // Check if the contact is selected in selectedTrip.contacts and update the cell's appearance
        let isSelected: Bool
        if let selectedContacts = selectedTrip.contacts as? Set<ContactEntity> {
            isSelected = selectedContacts.contains { $0.identifier == contact.identifier }
        } else {
            isSelected = false
        }

        cell.isSelected = isSelected
        cell.layer.borderWidth = isSelected ? 2.0 : 0.0
        cell.layer.borderColor = isSelected ? UIColor.blue.cgColor : nil
        cell.layer.cornerRadius = isSelected ? 10 : 0
    }
}
