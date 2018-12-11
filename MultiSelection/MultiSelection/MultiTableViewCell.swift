//
//  MultiTableViewCell.swift
//  MultiSelection
//
//  Created by mac on 26/09/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class MultiTableViewCell: UITableViewCell {
    @IBOutlet weak var emoji: UILabel!
    
    @IBOutlet weak var BankNAme: UILabel!
    
    @IBOutlet weak var ImageOut: UIImageView!
    
    var conversationSelected:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
