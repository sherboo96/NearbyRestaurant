//
//  PlaceCell.swift
//  NearbyRestaurant
//
//  Created by Mahmoud Sherbeny on 03/10/2021.
//

import UIKit

class PlaceCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setupName(name: String) {
        self.lblName.text = name
    }
    
}
