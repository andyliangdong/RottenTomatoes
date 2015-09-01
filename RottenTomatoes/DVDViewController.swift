//
//  DVDViewController.swift
//  RottenTomatoes
//
//  Created by Andy (Liang) Dong on 8/29/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class DVDViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
       
    @IBOutlet weak var dvdTableView: UITableView!
    @IBOutlet weak var dvdNetworkErrorLabel: UILabel!
    
    var dvdRefreshControl : UIRefreshControl!
    
    var dvds : [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
          
        self.loadByApi()
        
        dvdTableView.dataSource = self
        dvdTableView.delegate = self
        
        dvdRefreshControl = UIRefreshControl()
        dvdRefreshControl.addTarget(self, action:"onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        dvdTableView.insertSubview(dvdRefreshControl, atIndex: 0)
    }
    
    func loadByApi(){
       
        let cachedDataUrl = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json")!
        
        let request = NSURLRequest(URL: cachedDataUrl)
        
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) ->
            Void in
            
            if(error != nil) {
                println("Networking Error: \(error.localizedDescription)")
                self.dvdNetworkErrorLabel.hidden = false
            } else {
                var err: NSError?
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                if(err != nil) {
                    //If there is an error parsing JSON, print it to the console
                    println("JSON Error: \(err!.localizedDescription)")
                }
                if let json = json {
                    self.dvds = json["movies"] as? [NSDictionary]
                    self.dvdTableView.reloadData()
                }
            }
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dvds = dvds {
            return dvds.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("DvdCell", forIndexPath: indexPath) as! DvdCell
        let dvd = dvds![indexPath.row]
        
        cell.dvdTitleLabel.text = dvd["title"] as? String
        cell.dvdSynopsisLabel.text = dvd["synopsis"] as? String
        
        let url = NSURL(string: dvd.valueForKeyPath("posters.thumbnail") as! String)!
        cell.dvdPosterView.setImageWithURL(url)
        cell.dvdPosterView.layer.cornerRadius = 3
        cell.dvdPosterView.clipsToBounds = true
           
    return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath( indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as!  UITableViewCell
        let indexPath = dvdTableView.indexPathForCell(cell)!
        
        let dvd = dvds![indexPath.row]
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.movie = dvd
        
    }
   
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.dvdRefreshControl.endRefreshing()
        })
    }
    

}
