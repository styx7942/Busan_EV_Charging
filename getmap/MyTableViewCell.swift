//
//  MyTableViewCell.swift
//  getmap
//
//  Created by 이현호 on 2017. 11. 23..
//  Copyright © 2017년 이현호. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var csNmlbl: UILabel!
    @IBOutlet weak var cpTplbl: UILabel!
    @IBOutlet weak var addrlbl: UILabel!
    @IBOutlet weak var cpStatlbl: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
