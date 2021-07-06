import UIKit
import MapKit

enum YelpError: Error {
    case responseError
    case parseError
}

class YelpService : CoreService {
    
    let yelpBaseURL = "https://api.yelp.com/v3/businesses/search"
    let locationService = LocationService()
    
    override init() {}
    
    func getRestaurantsForUsersLocation(callback: @escaping (Restaurants?, Error?) -> ()){
        locationService.getUsersLocation()
        locationCompletionBlock = { locValue in
            self.getRestaurantsForLongLat(latitude: locValue.latitude, longitude: locValue.longitude, callback: callback)
        }
    }
    
    func getRestaurantsForLongLat(latitude: Double, longitude: Double, callback: @escaping (Restaurants?, Error?) -> ()){
        let urlString = "\(yelpBaseURL)?latitude=\(latitude)&longitude=\(longitude)"
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(Constants.yelpAPIKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        sendRequest(request: request) { (data, response, error) in
            if (error != nil) {
                callback(nil, YelpError.responseError)
            } else {
                if let restaurantResults = self.parse(json: data!) {
                    callback(restaurantResults, nil)
                } else {
                    callback(nil, YelpError.parseError)
                }
            }
        }
    }
    
    func parse(json: Data) -> Restaurants? {
        do {
            let decoder = JSONDecoder()
            let businesses = try decoder.decode(Restaurants.self, from: json)
            return businesses
        } catch {
            return nil
        }
    }
}


