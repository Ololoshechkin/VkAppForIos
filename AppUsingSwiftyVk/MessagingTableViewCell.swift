//
//  MessagingTableViewCell.swift
//  MyVkAppForIos
//
//  Created by Vadim on 22.02.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import Foundation
import UIKit
import SwiftyVK

class MessagingTableViewCell : UITableViewCell {
    
    public var friendId = ""
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBAction func sendButtonPress(_ sender: Any) {
        messageTextView.text = ""
    }
    
}
