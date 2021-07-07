import UIKit
import MapKit

public class RestaurantViewModel {
    let restaurants: Box<Restaurants?> = Box(nil)
    let annotations: Box<[MKAnnotation]> = Box([])
    var yelpService: YelpService!
    
    init(yelpService: YelpService) {
        self.yelpService = yelpService
    }
    
    func getRestaurantsForUsersLocation(){
        yelpService.getRestaurantsForUsersLocation {[weak self] (restaurants, error) in
            if(error == nil){
                self?.restaurants.value = restaurants
                self?.setMapAnnotations(restaurants: restaurants)
            } else {
                print(error!)
            }
        }
    }
    
    private func setMapAnnotations(restaurants: Restaurants?){
        var annotations: [MKAnnotation] = []
        
        for restaurant in  restaurants!.businesses {
            if restaurant.latitude == nil {continue}
            let annotation = MKPointAnnotation()
            annotation.title = restaurant.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude!, longitude: restaurant.longitude!)
            annotations.append(annotation)
        }
        self.annotations.value = annotations
    }
}
