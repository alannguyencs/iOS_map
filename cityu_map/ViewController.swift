//
//  ViewController.swift
//  cityu_map
//
//  Created by Alan on 3/21/18.
//  Copyright © 2018 Alan Nguyen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var map: MKMapView!
    let manager = CLLocationManager()
    var x0: Int = 0
    var y0: Int = 0
    var x1: Int = 0
    var y1: Int = 0
    var counter: Int = 0 //when counter >= 2 --> display direction
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations[0]

        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)

        
//        print (location.coordinate.longitude)
//        print (location.coordinate.latitude)
        let x: Int = Int(Float(location.coordinate.latitude) * 100000.0)
        let y: Int = Int(Float(location.coordinate.longitude) * 100000.0)
        //print ("\(x) : \(y)")
        updateDirection(x: x, y: y)
        self.map.showsUserLocation = true
    }
    
    func updateDirection(x: Int, y:Int){
        
        if counter % 5 == 1 {
            if counter < 15 {
                label.text = "Direction"
            }else{
                if (x-x0)*(x-x0) + (y-y0)*(y-y0) < 25{ //stop threshold
                    label.text = "Stop"
                }else{
                    let X1: Int = x1 - x0
                    let Y1: Int = y1 - y0
                    let X2: Int = x - x1
                    let Y2: Int = y - y1
                    
                    let crossProduct: Int = X1 * Y2 - X2 * Y1
                    
                    
                    if crossProduct > 125{ //turn threshold
                        label.text = "Turn right"
                    }else{
                        if crossProduct < -125{
                            label.text = "Turn left"
                        }else{
                            label.text = "Go straight forward"
                        }
                    }
                    
                    
                    
                    print (crossProduct)
                }
            }
            
            
            
            //update location
            x0 = x1
            y0 = y1
            x1 = x
            y1 = y
            
        }
        
        counter += 1
    }
}

