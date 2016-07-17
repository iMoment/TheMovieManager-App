//
//  MovieDetailViewController.swift
//  MyFavoriteMovies

import UIKit

// MovieDetailViewController: UIViewController

class MovieDetailViewController: UIViewController {
    
    // Properties
    
    var movie: TMDBMovie?
    var isFavorite = false
    var isWatchlist = false
    
    // Outlets
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var toggleFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var toggleWatchlistButton: UIBarButtonItem!
    
    // Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.translucent = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Actions
    
    @IBAction func toggleFavorite(sender: AnyObject) {

    }
    
    @IBAction func toggleWatchlist(sender: AnyObject) {

    }
}