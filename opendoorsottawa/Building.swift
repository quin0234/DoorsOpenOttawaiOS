//
//  BuildingStats.swift
//  opendoorsottawa
//
//  Created by Paul Quinnell on 2017-11-30.
//  Copyright © 2017 Paul Quinnell. All rights reserved.
//

import Foundation

struct Building:Decodable {
    let nameEN: String
    let descriptionEN: String
    let image: String
    let latitude: Double
    let longitude: Double
    let addressEN: String
    let city: String
    let province: String
    let postalCode: String
    let imageDescriptionEN: String
}
