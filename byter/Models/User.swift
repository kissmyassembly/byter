//
//  User.swift
//  byter
//
//  Created by Brian Casipit on 3/2/19.
//  Copyright © 2019 Gouri Jamakhandi. All rights reserved.
//

import Foundation

class User {
    //var spotify_id: String?
    var latitude: Double?
    var longitude: Double?
    //var artists: String?
    //var song: String?
    
    // TEMP
    var device_id: String?
    
    init(dictionary: [String: Any]) {
        //spotify_id = dictionary["spotify_id"] as? String ?? ""
        latitude = dictionary["latitude"] as? Double ?? 0
        longitude = dictionary["longitude"] as? Double ?? 0
        //artists = dictionary["artists"] as? String ?? ""
        //song = dictionary["song"] as? String ?? ""
        
        // TEMP
        device_id = dictionary["device_id"] as? String ?? ""
    }
    
    func asDictionary() -> [String: Any] {
        return [
            //"spotify_id": spotify_id!,
            "latitude": latitude!,
            "longitude": longitude!,
            //"artists": artists!,
            //"song": song!
            
            // TEMP
            "device_id": device_id!
        ]
    }
    
    class func users(dictionaries: [[String: Any]]) -> [User] {
        var users: [User] = []
        for dictionary in dictionaries {
            let user = User(dictionary: dictionary)
            users.append(user)
        }
        return users
    }
    
}
