//
//  Album.swift
//  Lyrics
//
//  Created by Martin Mitrevski on 30/05/15.
//  Copyright (c) 2015 Martin Mitrevski. All rights reserved.
//

import UIKit

class Album: NSObject {
   
    var albumName: String?
    var albumReleaseDate: String?
    var albumId: String?
    var albumImageURL: NSURL?
    
    init(dictionary: NSDictionary) {
        albumName = dictionary["album_name"] as? String
        albumReleaseDate = dictionary["album_release_date"] as? String
        albumId = dictionary["album_id"] as? String
        var uriString = dictionary["album_coverart_100x100"] as? String
        if uriString != nil {
            albumImageURL = NSURL(string: uriString!)
        }
    }
}
