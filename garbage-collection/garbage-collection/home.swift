//
//  home.swift
//  garbage-collection
//
//  Created by Sarthak Mangla on 7/24/19.
//  Copyright © 2019 Sarthak Mangla. All rights reserved.
//

import UIKit
import CoreLocation

class home: UIViewController, UIImagePickerControllerDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var buttonui: UIButton!
    var locationManager = CLLocationManager()
    static var serverUrl = URL(string: "http://127.0.0.1:5000")
    static var request = URLRequest(url:home.serverUrl!)
    @objc func update(){
        buttonui.setImage(UIImage(named: "buttonOff"), for: UIControl.State.normal)
        performSegue(withIdentifier: "afterPressed", sender: nil)
    }
    @IBAction func buttonpressed(_ sender: Any) {
        home.request.httpMethod = "POST";
        print(locationManager.location?.coordinate.latitude as Any, locationManager.location?.coordinate.longitude)
        home.request.setValue("x:\(String(describing: locationManager.location?.coordinate.latitude))", forHTTPHeaderField: "lat")
        home.request.setValue("x:\(String(describing: locationManager.location?.coordinate.longitude))", forHTTPHeaderField: "long")
        home.request.setValue("x:\(String(describing: locationManager.location?.timestamp))", forHTTPHeaderField: "time")
        let task = URLSession.shared.dataTask(with: home.request) {
            data, response, error in
            if error != nil {
                return
            }
        }
        task.resume()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        }
        buttonui.setImage(UIImage(named: "buttonOn"), for: UIControl.State.normal)
        let timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        home.request.setValue("x:\(locations.last?.coordinate.latitude)", forHTTPHeaderField: "lat")
        home.request.setValue("x:\(locations.last?.coordinate.longitude)", forHTTPHeaderField: "long")
        home.request.setValue("x:\(locations.last?.timestamp)", forHTTPHeaderField: "time")
    }

}
