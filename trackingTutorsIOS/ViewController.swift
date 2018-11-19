//
//  ViewController.swift
//  trackingTutorsIOS
//
//  Created by Brian Thomas O'Leary on 10/12/18.
//  Copyright © 2018 Brian Thomas O'Leary. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSMobileClient
import CoreLocation
import QuartzCore

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let URL_GET_LISTINGS = "http://localhost:8000/api/event/get/"
    
    var user:[User]?
    
    @IBOutlet weak var signOutButton: UIButton!
    
    var locationManager:CLLocationManager!
    
    func showSignIn() {
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            AWSAuthUIViewController
                .presentViewController(with: self.navigationController!,
                                       configuration: nil,
                                       completionHandler: { (provider: AWSSignInProvider, error: Error?) in
                                        if error != nil {
                                            print("Error occurred: \(String(describing: error))")
                                        } else {
                                            // Sign in successful.
                                            
                                        }
                })
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            presentAuthUIViewController()
        }
        determineMyCurrentLocation()
        setNeedsStatusBarAppearanceUpdate()
        print("Signed in Good")
        self.getJsonOfOneUser()
        print("Sign in done")
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
        print("Done!")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func presentAuthUIViewController() {
        let config = AWSAuthUIConfiguration()
        config.enableUserPoolsUI = true
        config.backgroundColor = UIColor.white
        config.font = UIFont (name: "Helvetica Neue", size: 12)
        config.isBackgroundColorFullScreen = true
        config.canCancel = true
        config.logoImage = UIImage(named: "AthleteJail")
        
        AWSAuthUIViewController.presentViewController(
            with: self.navigationController!,
            configuration: config, completionHandler: { (provider: AWSSignInProvider, error: Error?) in
                if error == nil {
                    // SignIn succeeded.
                } else {
                    // end user faced error while loggin in, take any required action here.
                }
        })
    }
    
    @IBAction func signOut(_ sender: Any) {
        AWSSignInManager.sharedInstance().logout(completionHandler: {(result: Any?, error: Error?) in
            
            // Note: The showSignIn() method used below was added by us previously while integrating the sign-in UI.
            self.presentAuthUIViewController()
        })
    }
    
    func getJsonOfOneUser(){
        
        let urlString = URL_GET_LISTINGS + "test"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of User object
                let userData = try JSONDecoder().decode([User].self, from: data)
                //Get back to the main queue
                DispatchQueue.main.async {
                    self.user = userData
                    print(self.user)
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
        print(self.user?.count)
    }
}

