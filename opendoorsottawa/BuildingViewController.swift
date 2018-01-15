//
//  BuildingViewController.swift
//  opendoorsottawa
//
//  Created by Paul Quinnell on 2017-11-30.
//  Copyright © 2017 Paul Quinnell. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

//downloads images from the server
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
//start of class
class BuildingViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var imageDes: UITextField!
    @IBAction func showMeWhere(_ sender: Any) {
        
        //defining destination
        let latitude:CLLocationDegrees = (blding?.latitude)!
        let longitude:CLLocationDegrees = (blding?.longitude)!
        
        let regionDistance:CLLocationDistance = 1000;
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey:NSValue(mkCoordinateSpan: regionSpan.span)]
   
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = blding?.nameEN
        mapItem.openInMaps(launchOptions: options)
    }
    
    
    @IBOutlet weak var addBox: UITextView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var imgBg: UIView!
    @IBOutlet weak var desBg: UIView!
    @IBOutlet weak var buildingName: UILabel!
    @IBOutlet weak var buildingDes: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    let manager = CLLocationManager()
    
    var pin:AnnotationPin!
    
    var blding:Building?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(ScrollView)
        
        imgBg.layer.cornerRadius = 5
        imgBg.clipsToBounds = true
        desBg.layer.cornerRadius = 5
        desBg.clipsToBounds = true
        
        
        buildingName.layer.cornerRadius = 5
        buildingName.clipsToBounds = true
        buildingName.text = blding?.nameEN
        buildingName.numberOfLines = 0
        buildingName.lineBreakMode = .byWordWrapping
        buildingName.font = UIFont.systemFont(ofSize: 14.0)

    
        let urlString = "https://doors-open-ottawa.mybluemix.net/" + (blding?.image)!.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        let url = URL(string: urlString)
        
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.downloadedFrom(url: url!)
       
        buildingDes.layer.cornerRadius = 5
        buildingDes.clipsToBounds = true
        buildingDes.text = blding?.descriptionEN
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        let addressLine1 = (blding?.addressEN)! + ", " + (blding?.city)!
        let addressLine2 = (blding?.province)! + ", " + (blding?.postalCode)!
        let address = addressLine1 + ", " + addressLine2
        
        addBox.text = address
        
        imageDes.text = blding?.imageDescriptionEN
        
        let latitude:CLLocationDegrees = (blding?.latitude)!
        let longitude:CLLocationDegrees = (blding?.longitude)!
        
        map.delegate = self
        map.mapType = .standard
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
        
        map.setRegion(region, animated: true)
        pin = AnnotationPin(title: "BUILDING", coordinate:coordinate)
        map.addAnnotation(pin)
        self.map.showsPointsOfInterest = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: pin, reuseIdentifier: "canada")
        annotationView.image = UIImage(named: "canada")
        let transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        annotationView.transform = transform
        return annotationView
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        ScrollView.contentSize = CGSize(width: 375, height: 1500)
    }
}
