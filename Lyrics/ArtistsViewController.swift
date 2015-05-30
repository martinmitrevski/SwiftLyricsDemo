//
//  ArtistsViewController.swift
//  Lyrics
//
//  Created by Martin Mitrevski on 29/05/15.
//  Copyright (c) 2015 Martin Mitrevski. All rights reserved.
//

import UIKit

class ArtistsViewController: AbstractViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!;
    var artists: Array<String> = Array<String>()
    lazy var images = Dictionary<String, UIImage>()
    var selectedArtist: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedArtists: Array<String> = NSUserDefaults.standardUserDefaults().valueForKey("artists") as? Array<String> {
            artists = savedArtists
        }
        
        self.navigationItem.title = "Artists"
        addRightButtonItem()
    }

    func addRightButtonItem() {
        var button: UIBarButtonItem = UIBarButtonItem (barButtonSystemItem: .Add, target: self, action: "showAddArtist")
        self.navigationItem.rightBarButtonItem = button
    }
    
    func showAddArtist() {
        var alert = UIAlertController(title: "Add new artist", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Insert new artist"
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { action in
            var textField = alert.textFields?.first as! UITextField
            var artist = textField.text
            self.fetchImageForArtist(artist)
            self.artists.append(artist)
            NSUserDefaults.standardUserDefaults().setValue(self.artists, forKey: "artists")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.tableView.reloadData()
            }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: table view
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: ArtistCell = tableView.dequeueReusableCellWithIdentifier("ArtistCell") as! ArtistCell
        var artist = artists[indexPath.row]
        var image: UIImage? = images[artist] as UIImage?
        
        if (image == nil) {
            image = UIImage(named: "default-placeholder")!
            self.fetchImageForArtist(artist)
        }
        
        cell.setupWithArtist(artist, image: image!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            if (editingStyle == .Delete) {
                artists.removeAtIndex(indexPath.row)
                tableView.reloadData()
            }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        selectedArtist = artists[indexPath.row]
        self.performSegueWithIdentifier("showArtist", sender: self)
    }
    
    // MARK: util
    func fetchImageForArtist(artist: String) {
        let dataTask = self.session.dataTaskWithURL(self.searchImageUriForArtist(artist)) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) in
            var json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options:nil, error:nil)
            if let jsonDictionary = json as? NSDictionary {
                if let photos = jsonDictionary["photos"] as? NSDictionary {
                    if let photo = photos["photo"] as? NSArray {
                        if let first = photo[0] as? NSDictionary {
                            var farm: NSNumber = first["farm"] as! NSNumber
                            var server: NSString = first["server"] as! NSString
                            var id: NSString = first["id"] as! NSString
                            var secret: NSString = first["secret"] as! NSString
                            var imageString = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
                            self.getImageAtLocation(imageString, artist: artist)
                        }
                        
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    func searchImageUriForArtist(artist: String) -> NSURL {
        let musicArtist = "\(artist) music"
        let escapedArtist = musicArtist.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let parameterString = "api_key=\(GlobalConstants.FlickrApiKey)&method=\(GlobalConstants.FlickrSearchPhotos)&text=\(escapedArtist)&format=json&nojsoncallback=1&per_page=1"
        let uriString = "\(GlobalConstants.FlickrEndpoint)?\(parameterString)"
        let url = NSURL(string: uriString)!
        return url
    }
    
    func getImageAtLocation(location: String, artist: String) {
        let url = NSURL(string: location)!
        let imageTask = session.dataTaskWithURL(url) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if let image = UIImage(data: data!) {
                self.images[artist] = image
                var index = find(self.artists, artist)!
                var indexPath = NSIndexPath(forRow: index, inSection: 0)
                dispatch_async(dispatch_get_main_queue(),{
                    self.tableView .reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                })
            }
        }
        imageTask.resume()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showArtist" {
            var next: ArtistViewController = segue.destinationViewController as! ArtistViewController
            next.artist = selectedArtist
        }
    }
    
}
