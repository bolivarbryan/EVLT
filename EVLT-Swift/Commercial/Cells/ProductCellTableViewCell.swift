//
//  ProductCellTableViewCell.swift
//  EVLT-Swift
//
//  Created by Bryan on 6/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

class ProductCellTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
