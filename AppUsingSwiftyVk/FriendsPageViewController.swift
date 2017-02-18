//
//  FriendsPageViewController.swift
//  AppUsingSwiftyVk
//
//  Created by Vadim on 15.02.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import Foundation
import UIKit
import SwiftyVK


public class FriendsPageViewController: UITableViewController {
    public var friendsArray = [(name: String, photo: UIImage)]()
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsArray.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = friendsArray[indexPath.row].name
        cell.imageView?.image = friendsArray[indexPath.row].photo
        return cell
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        friendsArray = Vkontakte.getFriendsWithPhotos(
            from: 0, to: Vkontakte.getFriendCount())
            ?? [(name: Vkontakte.getAccountName()!,
                 photo: Vkontakte.getMainPhoto())]
        friendsArray.sort {$0.name < $1.name}
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
