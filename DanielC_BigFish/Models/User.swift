//
//  User.swift
//  DanielC_BigFish
//
//  Created by Daniel Chapman on 7/6/21.
//

import Foundation
import MapKit

class User{
    
    static let shared = User()
    var location: CLLocationCoordinate2D?
    
    init(){}
    
    func updateLocation(location: CLLocationCoordinate2D){
        self.location = location
    }
}
