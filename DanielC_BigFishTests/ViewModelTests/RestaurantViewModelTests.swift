//
//  RestaurantViewModelTests.swift
//  DanielC_BigFishTests
//
//  Created by Daniel Chapman on 7/7/21.
//

import XCTest
import MapKit
@testable import DanielC_BigFish

class MockLocationService : LocationService {
//TODO:
}

class MockYelpService : YelpService {
    override func getRestaurantsForUsersLocation(callback: @escaping (Restaurants?, Error?) -> ()) {
        self.getRestaurantsForLongLat(latitude: 0, longitude: 0, callback: callback)
    }
    
    override func getRestaurantsForLongLat(latitude: Double, longitude: Double, callback: @escaping (Restaurants?, Error?) -> ()) {
        var restaurants = Restaurants.init()
        var restaurant = Restaurant.init()
        restaurant.name = "Tets Name"
        restaurants.businesses.append(restaurant)
        callback(restaurants, nil)
    }
}

class RestaurantViewModelTests: XCTestCase {
    var sut: RestaurantViewModel!
    var mockYelpService: MockYelpService!
    
    let networkMonitor = NetworkMonitor.shared
    let mockLocationService = MockLocationService()
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockYelpService = MockYelpService(locationService: mockLocationService)
        sut = RestaurantViewModel(yelpService: mockYelpService)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func testGetRestaurantsForUserLocation() throws {
        let expectation = self.expectation(
            description: "Find restaurants for user")
        
        sut.restaurants.bind { (restaurants) in
            if(restaurants != nil){
                expectation.fulfill()
            }
        }
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.sut.getRestaurantsForUsersLocation()
        }
        
        waitForExpectations(timeout: 8, handler: nil)
    }
}

