//
//  EntryFormController.swift
//  Flourish-Teaching
//
//  Created by Cesar Devers on 2/8/15.
//  Copyright (c) 2015 Cesar Devers. All rights reserved.
//

import UIKit
import CoreLocation

class EntryFormController: UIViewController, UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate
{
    
    let feelings = [
        ["title" : "the best", "color" : "#8647b7"],
        ["title" : "really good", "color": "#4870b7"],
        ["title" : "okay", "color" : "#45a85a"],
        ["title" : "meh", "color" : "#a8a23f"],
        ["title" : "not so great", "color" : "#c6802e"],
        ["title" : "the worst", "color" : "#b05050"]
    ]

    let picker = UIImageView(image: UIImage(named: "picker"))
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var keyboardHeight: CGFloat = 0
    
  
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var feelingButton: UIButton!
    
    @IBAction func togglePicker(sender: AnyObject)
    {
        picker.hidden ? openPicker() : closePicker()
    }
    
    @IBAction func setMood(sender: AnyObject)
    {
        feelingButton.tag = sender.tag
        feelingButton.setTitle(sender.currentTitle, forState: .Normal)
        feelingButton.setTitleColor(sender.titleColorForState(.Normal), forState: .Normal)
        
        closePicker()
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupLocationManager()
        titleInput.text = "best"
        createPicker()
    }
    
    // MARK: - Picker
    
    func createPicker()
    {
        picker.frame = CGRect(x: 45, y: 160, width: 286, height: 291)
        picker.alpha = 0
        picker.hidden = true
        picker.userInteractionEnabled = true
        
        var offset = 21
        
        for (index, feeling) in enumerate(feelings)
        {
            let button = UIButton()
            button.frame = CGRect(x: 13, y: offset, width: 260, height: 43)
            button.setTitleColor(UIColor(rgba: feeling["color"]!), forState: .Normal)
            button.setTitle(feeling["title"]!, forState: .Normal)
            button.tag = index
            button.addTarget(self, action: "setMood:", forControlEvents: .TouchUpInside)
            
            picker.addSubview(button)
            
            offset += 44
        }
        
        view.addSubview(picker)
    }
    
    func openPicker()
    {
        self.picker.hidden = false
        
        UIView.animateWithDuration(
            0.3,
            animations: {
                self.picker.frame = CGRect(x: 45, y: 160, width: 286, height: 291)
                self.picker.alpha = 1
            },
            completion: { finished in
            }
        )
    }
    
    func closePicker()
    {
        UIView.animateWithDuration(
            0.3,
            animations: {
                self.picker.frame = CGRect(x: 45, y: 140, width: 286, height: 291)
                self.picker.alpha = 0
            },
            completion: { finished in
                if (finished) {
                    self.picker.hidden = true
                }
            }
        )
    }
    
    func setupLocationManager()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        println("prompt the user to enable location services")
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        switch status
        {
            // User has not yet made a choice with regards to this application
        case .NotDetermined :
            manager.requestWhenInUseAuthorization()
            println("prompt the user to enable location services")
            
            // User has explicitly denied authorization for this application, or
            // location services are disabled in Settings.
        case .Denied :
            println("prompt the user to re-enable location services in settings")
            
            // User has granted authorization to use their location only when your app
            // is visible to them (it will be made visible to them if you continue to
            // receive location updates while in the background).  Authorization to use
            // launch APIs has not been granted.
        case .AuthorizedWhenInUse :
            manager.startUpdatingLocation()
            println("authorized when in use")
            
            // Currently only .Restricted falls here and there's not much we can do about it
            // so we'll simply move on with our lives
        default :
            //do nothing
            println("Other status")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        currentLocation = (locations.last as? CLLocation)
        
    }


    
}

