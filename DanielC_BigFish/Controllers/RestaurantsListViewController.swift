//
//  RestaurantsListViewController.swift
//  DanielC_BigFish
//
//  Created by Daniel Chapman on 7/6/21.
//

import UIKit

class RestaurantsListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchResultsLabel: UILabel!
    @IBOutlet weak var searchResultsNumberLabel: UILabel!
    @IBOutlet weak var searchResultsBGView: UIView!
    
    var restaurants: Restaurants? = nil
    
    let expandedView: CGFloat = 100
    var collapsedView: CGFloat {
        return UIScreen.main.bounds.height/2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
                
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(RestaurantsListViewController.panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    private func configUI(){
        self.searchResultsBGView.layer.cornerRadius = self.searchResultsBGView.frame.size.height/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.collapsedView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height - 100)
            })
    }
    
    func updateRestaurants(restaurants: Restaurants){
        DispatchQueue.main.async {
            self.restaurants = restaurants
            self.searchResultsNumberLabel.text = "\(restaurants.businesses.count)"
            self.searchResultsLabel.isHidden = false
            self.searchResultsNumberLabel.isHidden = false
            self.searchResultsBGView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)

        let y = self.view.frame.minY
        if (y + translation.y >= expandedView) && (y + translation.y <= collapsedView) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - expandedView) / -velocity.y) : Double((collapsedView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.collapsedView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.expandedView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
                }, completion: { [weak self] _ in
                    if ( velocity.y < 0 ) {
                        self?.tableView.isScrollEnabled = true
                    }
            })
        }
    }
}

extension RestaurantsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(restaurants == nil || restaurants?.businesses == nil) {return 0}
        return (restaurants?.businesses.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell") as? RestaurantTableViewCell
        let restaurant: Restaurant = (self.restaurants?.businesses[indexPath.row])!
        cell?.restaurantName.text = restaurant.name
        return cell!
    }
}

extension RestaurantsListViewController: UIGestureRecognizerDelegate {

    // Solution
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y

        let y = view.frame.minY
        if (y == expandedView && tableView.contentOffset.y == 0 && direction > 0) || (y == collapsedView) {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
        
        return false
    }
    

}
