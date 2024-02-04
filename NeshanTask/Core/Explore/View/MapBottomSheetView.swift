//
//  BottomSheetViewController.swift
//  NeshanTask
//
//  Created by Arman Zohourian on 1/22/24.
//

import UIKit
import Contacts


class MapBottomSheetViewController: BottomSheetViewController {
    
    // MARK: - Init and setup
    var locationDetails: LocationDetails? {
        didSet {
            setValues()
        }
    }
    var viewModel: ExploreViewModel
    var saveButtonAction:() -> ()
    weak var exploreDelegate: ExploreViewModelDelegate?
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Saint Louis"
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var provinceLabel: UILabel = {
        let label = UILabel()
        label.text = "California"
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "نشانی : "
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var addressValue: UILabel = {
        let label = UILabel()
        label.text = "Down street main ally"
        label.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        label.textColor = .white
        label.numberOfLines = 2
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return label
    }()
    private lazy var saveButton : UIButton = {
        var buttonConfig : UIButton = UIButton(type: .system)
        buttonConfig.translatesAutoresizingMaskIntoConstraints = false
        buttonConfig.setTitle("ذخیره", for: .normal)
        buttonConfig.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        buttonConfig.backgroundColor = UIColor.blue
        buttonConfig.setTitleColor(UIColor.white, for: .normal)
        buttonConfig.layer.cornerRadius = 15
        buttonConfig.clipsToBounds = true
        buttonConfig.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
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
    
    init(viewModel: ExploreViewModel, saveButtonAction: @escaping () ->()) {
        self.viewModel = viewModel
        self.saveButtonAction = saveButtonAction
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("The view has been dismissed!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupView()
        viewModel.fetchContacts()
    }
    
 
    private func setupView() {
        contentStackView.addArrangedSubview(overviewLabel)
        contentStackView.addArrangedSubview(locationStackView)
        contentStackView.addArrangedSubview(addressStackView)
        contentStackView.addArrangedSubview(contactCollection)
        contentStackView.addArrangedSubview(saveButton)
        setupArrangedSubViews()
        setupCustomContraints()
        self.setContent(content: contentStackView)
    }
    
    private func setupCustomContraints() {
        NSLayoutConstraint.activate([
            contactCollection.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            contactCollection.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            
            saveButton.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
        ])

    }
    private func setupArrangedSubViews() {
        locationStackView.addArrangedSubview(cityLabel)
        locationStackView.addArrangedSubview(provinceLabel)
        
        addressStackView.addArrangedSubview(addressValue)
        addressStackView.addArrangedSubview(addressLabel)
    }
    
    func setValues() {
        cityLabel.text = locationDetails?.city ?? "Saint Louis"
        provinceLabel.text = locationDetails?.state ?? "California"
        addressValue.text = locationDetails?.formattedAddress ?? "Address"
        neighbourhood.text = locationDetails?.neighbourhood ?? "Nothing to show"
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
    
    @objc func didTapSave() {
        saveButtonAction()
        dismissBottomSheet()
    }
}

//MARK: Protocols
extension MapBottomSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.contacts.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == viewModel.contacts.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddContactCollectionViewCell.identifier, for: indexPath) as! AddContactCollectionViewCell
            cell.tapCallback = { [weak self] in
                self?.exploreDelegate?.didTapAddContact()
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCollectionViewCell.identifier, for: indexPath) as! ContactCollectionViewCell
        let contact = viewModel.contacts[indexPath.row]
        cell.setContact(contact: contact)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
        let selectedContact = viewModel.contacts[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath)
        
        viewModel.appendContact(with: selectedContact)
        if viewModel.isSelectedContact(with: selectedContact) {
            cell?.layer.borderWidth = 2.0
            cell?.layer.borderColor = UIColor.blue.cgColor
            cell?.layer.cornerRadius = 10
        } else {
            cell?.layer.borderWidth = 0
        }
    }
}
