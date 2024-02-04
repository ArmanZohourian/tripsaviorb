//
//  AddContactCollectionViewCell.swift
//  NeshanTask
//
//  Created by Arman Zohourian on 1/27/24.
//

import UIKit

class AddContactCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AddContactCell"
    let customView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue // Set your desired background color
        view.layer.cornerRadius = 20 // Set half of the width/height to make it a circle
        view.clipsToBounds = true
        return view
    }()
    
    let plusLabel : UILabel = {
       var label = UILabel()
        label.text = "+"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    var tapCallback: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupButtonLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        addSubview(customView)
        addSubview(plusLabel)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        customView.addGestureRecognizer(tapGesture)
          
    }
    
    private func setupButtonLayout() {
        self.isUserInteractionEnabled = true 
        NSLayoutConstraint.activate([
            customView.centerXAnchor.constraint(equalTo: centerXAnchor),
            customView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            customView.heightAnchor.constraint(equalToConstant: 40),
            customView.widthAnchor.constraint(equalToConstant: 40),
            
            plusLabel.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            plusLabel.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
        ])
    }
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        print("Custom view tapped!")
        tapCallback?()
        // Add your custom logic here
    }
}
