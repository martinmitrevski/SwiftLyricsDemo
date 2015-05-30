//
//  ArtistCell.swift
//  Lyrics
//
//  Created by Martin Mitrevski on 29/05/15.
//  Copyright (c) 2015 Martin Mitrevski. All rights reserved.
//

import UIKit

class ArtistCell: UITableViewCell {

    @IBOutlet weak var title:UILabel!
    @IBOutlet weak var artistImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupWithArtist(artist: String, image: UIImage) {
        title.text = artist
        artistImage.image = image
    }
    

}
