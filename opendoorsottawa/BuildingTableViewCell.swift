//
//  BuildingTableViewCell.swift
//  opendoorsottawa
//
//  Created by Paul Quinnell on 2017-11-30.
//  Copyright © 2017 Paul Quinnell. All rights reserved.
//

import UIKit

class BuildingTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var buildingImg: UIImageView!
    @IBOutlet weak var buildingTitle: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
