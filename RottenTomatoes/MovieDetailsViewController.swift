//
//  MovieDetailsViewController.swift
//  RottenTomatoes
//
//  Created by Andy (Liang) Dong on 8/29/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        
        // "http://resizing.flixster.com/q7N6i-lodgiFIv2pn2fKcITzDFw=/o/dkpu1ddg7pbsk.cloudfront.net/movie/11/19/07/11190713_ori.jpg"
        
        var thumbnailStr : String = movie.valueForKeyPath("posters.thumbnail") as! String
       
        
        let url = NSURL(string : thumbnailStr)!
        imageView.setImageWithURL(url)
        
        var range = thumbnailStr.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            let originImgStr = thumbnailStr.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
            let originUrl = NSURL(string : originImgStr)!
            imageView.setImageWithURL(originUrl)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
