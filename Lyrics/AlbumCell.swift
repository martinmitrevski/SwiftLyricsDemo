//
//  AlbumCell.swift
//  Lyrics
//
//  Created by Martin Mitrevski on 30/05/15.
//  Copyright (c) 2015 Martin Mitrevski. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    @IBOutlet weak var albumName: UILabel!
    
    func setupWithAlbum(album: Album) {
        albumName.text = album.albumName
    }
}
