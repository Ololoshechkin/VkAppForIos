//
//  Vkontakte.swift
//  AppUsingSwiftyVk
//
//  Created by Vadim on 18.02.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import Foundation
import Darwin
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
    
    class func getMainUserId() -> String {
        var Id: String?
        var gotAnswer = false
        VK.API.Users.get([:]).send(
            onSuccess: {(response: JSON) -> () in
                for obj in response.array! {
                    Id = obj.dictionaryValue["id"]?.stringValue
                    break
                }
                gotAnswer = true},
            onError: {(error: Error) -> () in
                print("VK-ERROR: user.get fail")
                gotAnswer = true})
        while (!gotAnswer) {
            continue
        }
        return Id!
    }
    
    class func getName(byId userId: String) -> String? {
        var username: String?
        var gotAnswer = false
        VK.API.Users.get([VK.Arg.userId: userId]).send(
            onSuccess: {(response: JSON) -> () in
                for obj in response.array! {
                    username = (obj.dictionaryValue["first_name"]?.stringValue)! + " " + (obj.dictionaryValue["last_name"]?.stringValue)!
                }
                gotAnswer = true},
            onError: {(error: Error) -> () in
                print("VK-ERROR: user.get fail")
                gotAnswer = true})
        while (!gotAnswer) {
            continue
        }
        return username!
    }
    
    class func isOnline(id userId: String) -> Bool {
        var online = false
        var gotAnswer = false
        VK.API.Users.get([VK.Arg.userId: userId, VK.Arg.fields: "online"]).send(
            onSuccess: {(response: JSON) -> () in
                for obj in response.array! {
                    online = ((obj.dictionaryValue["online"]?.stringValue)! == "1")
                }
                gotAnswer = true},
            onError: {(error: Error) -> () in
                print("VK-ERROR: user.get fail")
                gotAnswer = true})
        while (!gotAnswer) {
            continue
        }
        return online
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
    
    class func getFriendCount(for userId: String = "main") -> Int {
        return getFriendNames(for: userId).count
    }
    
    class func getFriendsWithPhotos(from firstFriendPos: Int, to lastFriendPos: Int, for userId: String = "main")
        -> [(id: String, name: String, photo: UIImage)] {
        var friends = [(id: String, name: String, photo: UIImage)]()
        var gotAnswer = false
        var parameters = [VK.Arg.fields: "domain,photo_50", VK.Arg.offset: "\(firstFriendPos)",
                VK.Arg.count: "\(lastFriendPos - firstFriendPos + 1)"]
        if userId != "main" {
            parameters[VK.Arg.userId] = userId
        }
        VK.API.Friends.get(parameters).send(
            onSuccess: {(responce) in
                let items: [JSON] = responce.dictionary!["items"]!.array!
                for item in items {
                    let friendParams = item.dictionaryValue
                    let friendId = friendParams["id"]?.stringValue
                    let friendName = "\(friendParams["first_name"] ?? "") \(friendParams["last_name"] ?? "")"
                    let friendPhoto = getPhoto(byUrl: (friendParams["photo_50"]?.stringValue)!)
                    friends.append((id: friendId!, name: friendName, photo: friendPhoto))
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
    
    class func getFriendNamesAndIds(for userId: String = "main") -> [(id: String, name: String)] {
            var friends = [(id: String, name: String)]()
            var gotAnswer = false
            var parameters = [VK.Arg.fields: "domain"]
            if userId != "main" {
                parameters[VK.Arg.userId] = userId
            }
            VK.API.Friends.get(parameters).send(
                onSuccess: {(responce) in
                    let items: [JSON] = responce.dictionary!["items"]!.array!
                    for item in items {
                        let friendParams = item.dictionaryValue
                        let friendId = friendParams["id"]?.stringValue
                        let friendName = "\(friendParams["first_name"] ?? "") \(friendParams["last_name"] ?? "")"
                        friends.append((id: friendId!, name: friendName))
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
    
    class func getFriendPhotos(from firstFriendPos: Int, to lastFriendPos: Int, for userId: String = "main") -> [UIImage] {
            var friendPhotos = [UIImage]()
            var gotAnswer = false
            var parameters = [VK.Arg.fields: "photo_50", VK.Arg.offset: "\(firstFriendPos)",
                VK.Arg.count: "\(lastFriendPos - firstFriendPos + 1)"]
            if userId != "main" {
                parameters[VK.Arg.userId] = userId
            }
            VK.API.Friends.get(parameters).send(
                onSuccess: {(responce) in
                    let items: [JSON] = responce.dictionary!["items"]!.array!
                    for item in items {
                        let friendParams = item.dictionaryValue
                        let friendPhoto = getPhoto(byUrl: (friendParams["photo_50"]?.stringValue)!)
                        friendPhotos.append(friendPhoto)
                    }
                    gotAnswer = true},
                onError: {(error: Error) -> () in print("__________Friends.get.error__________")
                    gotAnswer = true},
                onProgress: {(x: Int64, y: Int64) -> () in
                    print("progress (x : \(x), y: \(y))")})
            while (!gotAnswer) {
                continue
            }
            return friendPhotos
    }
    
    private class func getUserPhoto(for userId: String = "main") -> UIImage {
        var photo: UIImage?
        var gotAnswer = false
        let parameters = (userId == "main" ? [VK.Arg.fields: "photo_max_orig"] : [VK.Arg.userId: userId, VK.Arg.fields: "photo_max_orig"])
        VK.API.Users.get(parameters).send(
            onSuccess: {(response: JSON) -> () in
                for obj in response.array! {
                    let mainPhotoPath: String = (obj.dictionaryValue["photo_max_orig"]?.stringValue)!
                    photo = getPhoto(byUrl: mainPhotoPath)
                }
                gotAnswer = true},
            onError: {(error: Error) -> () in
                print("VK-ERROR: users.get fail")
                gotAnswer = true})
        while (!gotAnswer) {
            continue
        }
        return photo!
    }
    
    public class func getMainPhoto(for userId: String = "main") -> UIImage {
        var photo: UIImage?
        var gotAnswer = false
        let parameters = (userId == "main" ? [VK.Arg.albumId: "profile"] : [VK.Arg.userId: userId, VK.Arg.albumId: "profile"])
        VK.API.Photos.get(parameters).send(
            onSuccess: {(response: JSON) -> () in
                let mainPhotos = response.dictionaryValue["items"]?.arrayValue
                let lastPhoto = mainPhotos?.last?.dictionaryValue
                let width: String = (lastPhoto?["width"]?.stringValue) ?? "604"
                let mainPhotoPath: String = (lastPhoto?["photo_\(width)"]?.stringValue ?? "none")!
                if mainPhotoPath != "none" {
                    photo = getPhoto(byUrl: mainPhotoPath)
                }
                gotAnswer = true
        },
            onError: {(error: Error) -> () in
                print("VK-ERROR: photos.get fail")
                gotAnswer = true})
        while !gotAnswer {
            continue
        }
        if photo == nil {
            photo = getUserPhoto(for: userId)
        }
        return photo!
    }
    
    
    class func getFriendNames(for userId: String = "main") -> [String] {
        var friends = [String]()
        var gotAnswer = false
        let parameters = (userId == "main" ? [VK.Arg.fields: "domain"] : [VK.Arg.userId: userId, VK.Arg.fields: "domain"])
        VK.API.Friends.get(parameters).send(
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

    class func getMessages(with friendId: String,
                           offset ofset: Int,
                           count cnt: Int) -> [(message: String, isOwnerMessage: Bool)] {
        var messages = [(message: String, isOwnerMessage: Bool)]()
        var gotAnswer = false
        let parameters = [VK.Arg.userId: friendId, VK.Arg.offset: "\(ofset)", VK.Arg.count: "\(cnt)"]
        VK.API.Messages.getHistory(parameters).send(
            onSuccess: { (responce: JSON) in
                let messageDicts = responce.dictionary?["items"]?.arrayValue
                for messageDict in messageDicts! {
                    messages.append((message: messageDict["body"].stringValue,
                                     isOwnerMessage: messageDict["user_id"].stringValue != messageDict["from_id"].stringValue))
                }
                gotAnswer = true
        },
            onError: { (err: Error) in
                print("message error \(err)")
                gotAnswer = true
        }) { (x: Int64, y: Int64) in
            print("progress (\(x), \(y))")
        }
        while !gotAnswer {
            continue
        }
        return messages
    }
    
    
}
