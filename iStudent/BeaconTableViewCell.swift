//
//  BeaconTableViewCell.swift
//  iStudent
//
//  Created by Vincent Lee on 2017-11-17.
//  Copyright © 2017 TeamBrunch. All rights reserved.
//

import UIKit

class BeaconTableViewCell: UITableViewCell {
    
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
