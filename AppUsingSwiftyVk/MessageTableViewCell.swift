//
//  MessageTableViewCell.swift
//  MyVkAppForIos
//
//  Created by Vadim on 27.02.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import Foundation
import UIKit

class MessageTableViewCell : UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    public func setMessage(text txt: String) {
        messageLabel.text = txt
        messageLabel.sizeToFit()
    }
    
}
