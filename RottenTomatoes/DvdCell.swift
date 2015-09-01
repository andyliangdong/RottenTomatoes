//
//  DvdCell.swift
//  RottenTomatoes
//
//  Created by Andy (Liang) Dong on 8/29/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class DvdCell: UITableViewCell {


    @IBOutlet weak var dvdTitleLabel: UILabel!
    @IBOutlet weak var dvdSynopsisLabel: UILabel!
    @IBOutlet weak var dvdPosterView: UIImageView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
