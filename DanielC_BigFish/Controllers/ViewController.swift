//
//  ViewController.swift
//  DanielC_BigFish
//
//  Created by Daniel Chapman on 7/6/21.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    
    let viewModel = RestaurantViewModel(yelpService: YelpService(locationService: LocationService()))
    let restaurantList = RestaurantsListViewController()
    var restaurants: Restaurants? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBottomSheetView()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getRestaurantsForUsersLocation()
    }
    
    private func setupBindings(){
        viewModel.restaurants.bind { [self] (restaurants) in
            self.restaurants = restaurants
            if(restaurants != nil){
                self.restaurantList.updateRestaurants(restaurants: restaurants!)
            }
        }
        
        viewModel.annotations.bind { [self] (annotations: [MKAnnotation]) in
            updateMapView(annotations: annotations)
        }
    }
    
    private func updateMapView(annotations: [MKAnnotation]?){
        if(annotations == nil || annotations!.count == 0) { return }
        
        let viewRegion = MKCoordinateRegion(center: User.shared.location!, latitudinalMeters: 1500, longitudinalMeters: 1500)
        DispatchQueue.main.async{
            self.mapView.addAnnotations(annotations!)
            self.mapView.setRegion(viewRegion, animated: false)
            self.mapView.showsUserLocation = true
            
        }
    }
    
    func addBottomSheetView(scrollable: Bool? = true) {
        restaurantList.view.frame = self.view.frame
        self.addChild(restaurantList)
        self.view.addSubview(restaurantList.view)
        restaurantList.didMove(toParent: self)
    }
}

