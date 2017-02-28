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


public class FriendsPageViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    public var lastUserId: String = "main"
    var friendsArray = [(id: String, name: String, photo: UIImage?)]()
    var searchedFriends = [(id: String, name: String, photo: UIImage?)]()
    var searchIsActive = false
    var searchBarIsEmpty = true
    private let bucketSize = 6
    private let halfBucketSize = 3
    
    private func uploadBucket(from bucketBegin: Int, to bucketEnd: Int) {
        let bucket = Vkontakte.getFriendPhotos(from: bucketBegin, to: bucketEnd, for: lastUserId)
        for i in bucketBegin...bucketEnd {
            friendsArray[i].photo = bucket[i - bucketBegin]
        }
    }
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBarIsEmpty ? friendsArray.count : searchedFriends.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let currentFriendArray = (searchBarIsEmpty ? friendsArray : searchedFriends)
        cell.textLabel?.text = currentFriendArray[indexPath.row].name
        if currentFriendArray[indexPath.row].photo == nil {
            uploadBucket(from: indexPath.row - halfBucketSize, to: indexPath.row + halfBucketSize)
            if let photo = currentFriendArray[indexPath.row].photo {
                cell.imageView?.image = photo
            }
        }
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //UserDefaults.standard.setValue(friendsArray, forKey: "\(lastUserId)/friendsArray")
        //UserDefaults.standard.synchronize()
        let friendPageController = self.storyboard?.instantiateViewController(withIdentifier: "FriendPage") as! FriendPageViewController
        let currentFriendArray = (searchBarIsEmpty ? friendsArray : searchedFriends)
        friendPageController.friendId = currentFriendArray[indexPath.row].id
        navigationItem.backBarButtonItem?.title = "all friends"
        navigationController?.isNavigationBarHidden = false
        navigationController?.pushViewController(friendPageController, animated: true)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        let friendNonImageParams = Vkontakte.getFriendNamesAndIds(for: lastUserId);
        for friendNonImageParam in friendNonImageParams {
            friendsArray.append((id: friendNonImageParam.id, name: friendNonImageParam.name, photo: nil))
        }
        uploadBucket(from: 0, to: bucketSize)
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

public extension FriendsPageViewController {
    
    public func filterContent(by searchText: String) {
        if friendsArray.isEmpty {
            searchedFriends = []
            return
        }
        searchedFriends = friendsArray.filter({(friend: (id: String, name: String, photo: UIImage?)) -> Bool in
            return friend.name.lowercased().range(of: searchText.lowercased()) != nil
        })
    }
    
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            searchBarIsEmpty = false
            filterContent(by: searchText)
        } else {
            searchBarIsEmpty = true
            searchedFriends = []
        }
        self.tableView.reloadData()
    }
    
}
