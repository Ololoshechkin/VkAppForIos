//
//  FriendPageViewController.swift
//  MyVkAppForIos
//
//  Created by Vadim on 19.02.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import Foundation
import UIKit
import SwiftyVK

class FriendPageViewController: UIViewController {
    
    var friendId: String = "none"
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var isOnlineLabel: UILabel!
    
    
    @IBAction func friendsButtonPress(_ sender: Any) {
        let friendsListPageController = self.storyboard?.instantiateViewController(withIdentifier: "FriendsList") as! FriendsPageViewController
        friendsListPageController.lastUserId = friendId
        navigationItem.backBarButtonItem?.title = "to \(usernameLabel.text)"
        navigationController?.isNavigationBarHidden = false
        navigationController?.pushViewController(friendsListPageController, animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let mainPhoto = resizedImage(image: Vkontakte.getMainPhoto(for: friendId))
        photo.image = mainPhoto!
        usernameLabel.text = Vkontakte.getName(byId: friendId)!
        isOnlineLabel.text = Vkontakte.isOnline(id: friendId) ? "online" : "offline"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resizedImage(image: UIImage) -> UIImage? {
        let newWidth = UIScreen.main.bounds.width - 30
        if (newWidth >= image.size.width) {
            return image
        }
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
