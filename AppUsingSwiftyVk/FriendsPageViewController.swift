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
    
    public var lastUserId: String = "main"
    var friendsArray = [(id: String, name: String, photo: UIImage)?]()
    var friendCount = 0
    private let bucketSize = 20
    private let halfBucketSize = 10
    
    private func uploadBucket(from bucketBegin: Int, to bucketEnd: Int) {
        let bucket = Vkontakte.getFriendsWithPhotos(from: bucketBegin, to: bucketEnd, for: lastUserId)
        for i in bucketBegin...bucketEnd {
            friendsArray[i] = bucket[i - bucketBegin]
        }
    }
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendCount
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
        if friendsArray[indexPath.row] == nil {
            uploadBucket(from: indexPath.row - halfBucketSize,
                         to: indexPath.row + halfBucketSize)
        }
        let cell = UITableViewCell()
        cell.textLabel?.text = friendsArray[indexPath.row]?.name
        cell.imageView?.image = friendsArray[indexPath.row]?.photo
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friendPageController = self.storyboard?.instantiateViewController(withIdentifier: "FriendPage") as! FriendPageViewController
        friendPageController.friendId = (friendsArray[indexPath.row]?.id)!
        navigationItem.backBarButtonItem?.title = "all friends"
        navigationController?.isNavigationBarHidden = false
        navigationController?.pushViewController(friendPageController, animated: true)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        friendCount = Vkontakte.getFriendCount(for: lastUserId)
        friendsArray = [(id: String, name: String, photo: UIImage)?](repeating: nil, count: friendCount)
        uploadBucket(from: 0, to: bucketSize)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
