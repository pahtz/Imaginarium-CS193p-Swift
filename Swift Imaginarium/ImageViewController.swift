//
//  ImageViewController.swift
//  Swift Imaginarium
//
//  Created by Paul Yu on 11/6/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView : UIScrollView
    @IBOutlet var spinner : UIActivityIndicatorView
    
    var imageURL : NSURL? {
    didSet {
        startDownloadingImage()
    }
    }
    
    var imageView : UIImageView = UIImageView()
    
    var image : UIImage? {
    get {
        return imageView.image
    }
    set {
        imageView.image = newValue
        imageView.sizeToFit()
        setScrollView()
        spinner.stopAnimating()
    }
    }
    
    func startDownloadingImage()
    {
        if (imageURL)
        {
            if (spinner) { spinner.startAnimating() }
            let request = NSURLRequest(URL: imageURL)
            let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
            let session = NSURLSession(configuration: configuration)
            let completion : (localfile : NSURL!, response : NSURLResponse!, error : NSError!) -> Void = { localfile, response, error in
                if (!error)
                {
                    if (request.URL.isEqual(self.imageURL)) {
                        var newImage = UIImage(data: NSData(contentsOfURL: localfile))
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.image = newImage })
                    }
                }
            }
            let task = session.downloadTaskWithRequest(request, completion)
            task.resume()
        }
    }
    
    func setScrollView() {
        if (scrollView) {
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 2.0
            scrollView.delegate = self
            if (imageView.image) {
                scrollView.contentSize = imageView.image.size
            }
            
        }
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView!
    {
        return imageView
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        scrollView.addSubview(self.imageView)
        setScrollView()
    }
    
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
