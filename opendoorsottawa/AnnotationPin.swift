//
//  AnnotationPin.swift
//  opendoorsottawa
//
//  Created by Paul Quinnell on 2017-12-05.
//  Copyright © 2017 Paul Quinnell. All rights reserved.
//

import MapKit
class AnnotationPin: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.coordinate = coordinate
    }
}
