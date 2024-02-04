//
//  LocationDetails.swift
//  NeshanTask
//
//  Created by Arman Zohourian on 1/24/24.
//

import Foundation

struct LocationDetails: Codable {
    let status, neighbourhood, municipalityZone, state: String?
    let city: String?
    let inTrafficZone, inOddEvenZone: Bool?
    let routeName, routeType: String?
    let place: String?
    let district, formattedAddress: String?
    let village: String?
    let county: String?
}

