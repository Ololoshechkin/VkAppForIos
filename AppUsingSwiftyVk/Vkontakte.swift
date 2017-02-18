//
//  Vkontakte.swift
//  AppUsingSwiftyVk
//
//  Created by Vadim on 18.02.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import Foundation
import SwiftyVK

class Vkontakte {
    
    class func getPhoto(byUrl photoUrl: String) -> UIImage {
        let imageUrl = NSURL.init(string: photoUrl)
        let imageData = NSData.init(contentsOf: imageUrl as! URL)
        return UIImage.init(data: imageData as! Data)!
    }
    
    class func logIn() {
        VK.logIn()
    }
    
    
    class func getName(byId userId: String) -> String? {
        var name: String?
        var gotAnswer = false
        VK.API.Users.get([VK.Arg.userId: userId]).send(
            onSuccess: {(responce: JSON) -> () in
                print("responce:\n\(responce)")
                if responce == nil {
                    print("NILL, fuck u are?!")
                } else {
                for obj in responce.array! {
                    let dict = obj.dictionary
                    print("responce:\n\(dict)")
                    name = "\(dict?["first_name"]?.stringValue) \(dict?["last_name"]?.stringValue)"
                }
                }
                gotAnswer = true},
            onError: { (error: Error) in
                print("----------ERROR GETTING NAME----------\n\(error)")
                gotAnswer = true},
            onProgress: {(x: Int64, y: Int64) -> () in
                print("progress (\(x), \(y))")})
        while (!gotAnswer) {
            continue
        }
        return name
    }
    
    
    class func getAccountName() -> String? {
        var accountName: String? = nil
        var gotAnswer = false
        VK.API.Account.getProfileInfo().send(
            onSuccess: {(response: JSON) -> () in
                let responceDict = response.dictionaryObject
                let name: String = responceDict?["first_name"] as! String
                let surname: String = responceDict?["last_name"] as! String
                accountName = "\(name) \(surname)"
                gotAnswer = true
            },
            onError: {(error: Error) -> () in
                print("VK-ERROR: account.getProfileInfo fail")
                gotAnswer = true})
        while (!gotAnswer) {
            continue
        }
        return accountName
    }
    
    
    class func getPhoto(byId photoId: String) -> UIImage? {
        var photo: UIImage?
        var gotAnswer = false
        VK.API.Photos.getById([VK.Arg.photos: photoId]).send(
            onSuccess: {(response: JSON) -> () in
                for responceDict in response.arrayValue {
                    let width = 604
                    let photoKeyName = "photo_\(width)"
                    photo = getPhoto(byId: responceDict[photoKeyName].stringValue)
                    gotAnswer = true
                }
            },
            onError: {(error: Error) -> () in
                print("VK-ERROR: photos.get fail")
                gotAnswer = true})
        while (!gotAnswer) {
            continue
        }
        return photo
    }
    
    class func getFriendCount() -> Int {
        return getFriendNames().count
    }
    
    class func getFriendsWithPhotos(from firstFriendPos: Int, to lastFriendPos: Int) -> [(name: String, photo: UIImage)] {
        var friends = [(name: String, photo: UIImage)]()
        var gotAnswer = false
        VK.API.Friends.get([VK.Arg.fields: "domain,photo_50"]).send(
            onSuccess: {(responce) in
                let items: [JSON] = responce.dictionary!["items"]!.array!
                for item in items {
                    let friendParams = item.dictionaryValue
                    let friendName = "\(friendParams["first_name"] ?? "") \(friendParams["last_name"] ?? "")"
                    let friendPhoto = getPhoto(byUrl: (friendParams["photo_50"]?.stringValue)!)
                    friends.append((name: friendName, photo: friendPhoto))
                }
                gotAnswer = true},
            onError: {(error: Error) -> () in print("__________Friends.get.error__________")
                gotAnswer = true},
            onProgress: {(x: Int64, y: Int64) -> () in
                print("progress (x : \(x), y: \(y))")})
        while (!gotAnswer) {
            continue
        }
        return friends
    }
    
    class func getMainPhoto() -> UIImage {
        var photo: UIImage?
        var gotAnswer = false
        VK.API.Photos.get([VK.Arg.albumId: "profile"]).send(
            onSuccess: {(response: JSON) -> () in
                let mainPhotos = response.dictionaryValue["items"]?.arrayValue
                let lastPhoto = mainPhotos?.last?.dictionaryValue
                let width: String = (lastPhoto?["width"]?.stringValue)!
                let mainPhotoPath = lastPhoto?["photo_\(width)"]
                let imageUrl = NSURL.init(string: (mainPhotoPath?.stringValue)!)
                let imageData = NSData.init(contentsOf: imageUrl as! URL)
                photo = UIImage.init(data: imageData as! Data)
                gotAnswer = true
            },
            onError: {(error: Error) -> () in
                print("VK-ERROR: photos.get fail")
                gotAnswer = true})
        while (!gotAnswer) {
            continue
        }
        return photo!
    }
    
    
    class func getFriendNames() -> [String] {
        var friends = [String]()
        var gotAnswer = false
        VK.API.Friends.get([VK.Arg.fields: "domain"]).send(
            onSuccess: {(responce) in
                let items: [JSON] = responce.dictionary!["items"]!.array!
                for item in items {
                    let friendParams = item.dictionaryValue
                    friends.append("\(friendParams["first_name"] ?? "") \(friendParams["last_name"] ?? "")")
                }
                gotAnswer = true},
            onError: {(error: Error) -> () in print("__________Friends.get.error__________")
                gotAnswer = true},
            onProgress: {(x: Int64, y: Int64) -> () in
                print("progress (x : \(x), y: \(y))")})
        while (!gotAnswer) {
            continue
        }
        return friends
    }
    
    
    class func setOnline() {
        VK.API.Account.setOnline()
    }
    
    
    class func setOffline() {
        VK.API.Account.setOffline()
    }
    
    
    
}
