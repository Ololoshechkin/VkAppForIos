//
//  MessagesViewController.swift
//  MyVkAppForIos
//
//  Created by Vadim on 22.02.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import Foundation
import UIKit
import SwiftyVK

class MessagesViewController: UITableViewController {
    
    public var friendId: String = ""
    
    private var messageCount: Int = 0
    
    private var messages: [(message: String, isOwnerMessage: Bool)] = []
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return messages.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessagingCell", for: indexPath) as! MessagingTableViewCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
        cell.setMessage(text: messages[indexPath.row].message)
        cell.backgroundColor = (messages[indexPath.row].isOwnerMessage ? #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        messages = Vkontakte.getMessages(with: friendId, offset: 0, count: 30)
        tableView.estimatedRowHeight = 110.0
        tableView.rowHeight = UITableViewAutomaticDimension
        messageCount = messages.count
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
