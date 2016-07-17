//
//  TMDBAuthViewController.swift
//  TheMovieManager

import UIKit

// TMDBAuthViewController: UIViewController

class TMDBAuthViewController: UIViewController {

    // Properties
    
    var urlRequest: NSURLRequest? = nil
    var requestToken: String? = nil
    var completionHandlerForView: ((success: Bool, errorString: String?) -> Void)? = nil
    
    // Outlets
    
    @IBOutlet weak var webView: UIWebView!
    
    // Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        navigationItem.title = "TheMovieDB Auth"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(cancelAuth))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let urlRequest = urlRequest {
            webView.loadRequest(urlRequest)
        }
    }
    
    // Cancel Auth Flow
    
    func cancelAuth() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// TMDBAuthViewController: UIWebViewDelegate

extension TMDBAuthViewController: UIWebViewDelegate {
    
    // TODO: Add implementation here
}