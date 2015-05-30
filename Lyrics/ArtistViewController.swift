//
//  ArtistViewController.swift
//  Lyrics
//
//  Created by Martin Mitrevski on 30/05/15.
//  Copyright (c) 2015 Martin Mitrevski. All rights reserved.
//

import UIKit

class ArtistViewController: AbstractViewController, UITableViewDataSource, UITableViewDelegate {
    
    var artist: String?
    
    @IBOutlet weak var tableView: UITableView!
    var albums = Array<Album>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = artist
        loadAlbumsForArtist(artist!)
    }
    
    func loadAlbumsForArtist(artist: String) {
        var baseUri = "\(GlobalConstants.MusixMatchEndpoint)/\(GlobalConstants.MusixMatchSearchArtist)"
        var uriParameters = "\(baseUri)?apikey=\(GlobalConstants.MusixMatchApiKey)&q_artist=\(artist)&page_size=1"
        var url = NSURL(string: uriParameters)!
        var artistsTask = session.dataTaskWithURL(url, completionHandler: { (data, response, error) in
            var json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
            if let jsonDict = json as? NSDictionary {
                if let message = jsonDict["message"] as? NSDictionary {
                    if let body = message["body"] as? NSDictionary {
                        if let artistList = body["artist_list"] as? NSArray {
                            if let first = artistList[0] as? NSDictionary {
                                if let artistDict = first["artist"] as? NSDictionary {
                                    var artistId = artistDict["artist_id"] as! NSNumber
                                    self.albumsForArtistWithId(artistId)
                                }
                            }
                        }
                    }
                }
            }
        })
        artistsTask.resume()
    }
    
    func albumsForArtistWithId(artistId: NSNumber) {
        var baseUri = "\(GlobalConstants.MusixMatchEndpoint)/\(GlobalConstants.MusixMatchSearchAlbums)"
        var uriParameters = "\(baseUri)?apikey=\(GlobalConstants.MusixMatchApiKey)&artist_id=\(artistId)&page_size=100&s_release_date=desc"
        var url = NSURL(string: uriParameters)!
        var albumsTask = session.dataTaskWithURL(url, completionHandler: { (data, response, error) in
            var json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
            if let jsonDict = json as? NSDictionary {
                if let message = jsonDict["message"] as? NSDictionary {
                    if let body = message["body"] as? NSDictionary {
                        if let albumList = body["album_list"] as? NSArray {
                            for album in albumList {
                                var albumDict: NSDictionary = album["album"] as! NSDictionary
                                var releaseType = albumDict["album_release_type"] as? String
                                if releaseType == "Album" {
                                    var anAlbum: Album = Album(dictionary: albumDict)
                                    self.albums.append(anAlbum)
                                }
                            }
                            dispatch_async(dispatch_get_main_queue(),{
                                self.tableView.reloadData()
                            })
                        }
                    }
                }
            }
        })
        albumsTask.resume()
    }
    
    // MARK: table view
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: AlbumCell = tableView .dequeueReusableCellWithIdentifier("AlbumCell") as! AlbumCell
        cell.setupWithAlbum(albums[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
    }

}
