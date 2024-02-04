//
//  GetLocationDetails.swift
//  NeshanTask
//
//  Created by Arman Zohourian on 1/24/24.
//

import Foundation
enum GetLocationDetails: RequestProtocol {

    case getLocationDetailsWith(selectedLatitude: Double, selectedLongtitude: Double)
    
    var path: String {
        "/v5/reverse"
    }
    
    var reuqestType: RequestType {
        .GET
    }
    
    var addAuthorizationToken: Bool {
        return false
    }
    
    var urlParams: [String : String?] {
        switch self {
        case let .getLocationDetailsWith(selectedLatitude, selectedLongtitude):
            return ["lat" : String(selectedLatitude), "lng": String(selectedLongtitude)]
        }
    }
    
    var headers: [String : String] {
        ["Api-Key" : "service.a81171aef7cb4b638458e1718054598b"]
    }
}
