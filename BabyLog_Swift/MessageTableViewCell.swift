//
//  MessageTableViewCell.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 7/16/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var babyNameLabel: UILabel!
    
    @IBOutlet weak var lastMsgLabel: UILabel!
    
    @IBOutlet weak var lastChatTimeLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
