//
//  MoviesViewController.swift
//  RottenTomatoes
//
//  Created by Andy (Liang) Dong on 8/29/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate   {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var networkErrorLabel: UILabel!
    
    
    var refreshControl : UIRefreshControl!
    
    
    var movies : [NSDictionary]?
    var filteredMovies : [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadByApi("box_office")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:"onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    } 
   
    func loadByApi(type : String){
       
        let apikey = "dagqdghwaq3e3mxyrp7kmmj5"
        let cachedDataUrl = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/\(type).json?apikey=\(apikey)&limit=30&country=us")!
        
        let request = NSURLRequest(URL: cachedDataUrl)
        
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) ->
            Void in
            
            if(error != nil) {
                println("Networking Error: \(error.localizedDescription)")
                self.networkErrorLabel.hidden = false
            } else {
                var err: NSError?
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                if(err != nil) {
                    //If there is an error parsing JSON, print it to the console
                    println("JSON Error: \(err!.localizedDescription)")
                }
                if let json = json {
                    self.movies = json["movies"] as? [NSDictionary]
                    self.tableView.reloadData()
                }
            }
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       if let movies = movies {
                return movies.count
       } else {
                return 0
       }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        var movie : NSDictionary
       
        movie = movies![indexPath.row]
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
        cell.posterView.setImageWithURL(url)
        cell.posterView.layer.cornerRadius = 3
        cell.posterView.clipsToBounds = true
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        tableView.deselectRowAtIndexPath( indexPath, animated: true)
    }
    
    // MARK: - Navigation


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        var cell = sender as!  UITableViewCell
        
        let indexPath = tableView.indexPathForCell(cell)!
        
        var movie : NSDictionary
        movie = movies![indexPath.row]
       
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.movie = movie
        
    }
    
    
    // for refresh the data
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))
            ),
        dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }
    
    
    
    
    // try to do the search bar but it is not working
    /*
    func filterContentForSearchText(searchText: String, scope: String = "titleLabel") {
        filteredMovies = movies!.filter({( movie : NSDictionary) -> Bool in
            
            var categoryMatch = (scope == "titleLabel")
            let title = movie["title"] as! String
            var stringMatch = title.rangeOfString(searchText)
            
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    func searchController(controller: UISearchController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString, scope: "titleLabel")
        return true
    }
    
    func searchController(controller: UISearchController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchBarControl.text, scope: "titleLabel")
        return true
    }
*/
}
