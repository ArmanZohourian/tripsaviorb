//
//  TripCellView.swift
//  NeshanTask
//
//  Created by Arman Zohourian on 1/30/24.
//

import Foundation
import UIKit

class TripTableViewCell: UITableViewCell {
    
    static let identifier = "TripCell"
    
    var cityNameLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var stateLabel : UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(stateLabel)
        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cityNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cityNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),  // Align to the right side

            stateLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 4),
            stateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),  // Align to the right side
            stateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    
    func setValues(with trip: TripEntity) {
        cityNameLabel.text = trip.location?.city ?? "City Name Not Available"
        stateLabel.text = trip.location?.formattedAddress ?? "State Not Available"
    }
}
