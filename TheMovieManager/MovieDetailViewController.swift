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
        activityIndicator.alpha = 1.0
        activityIndicator.startAnimating()
        
        // Set the UI, check if movie is a favorite/watchlist and update the buttons
        if let movie = movie {
            
            // Set the title
            if let releaseYear = movie.releaseYear {
                navigationItem.title = "\(movie.title) (\(releaseYear))"
            } else {
                navigationItem.title = "\(movie.title)"
            }
            
            // Set default UI ...
            posterImageView.image = UIImage(named: "MissingPoster")
            isFavorite = false
            
            // Is movie favorite?
            TMDBClient.sharedInstance().getFavoriteMovies { (movies, error) in
                if let movies = movies {
                    
                    for movie in movies {
                        if movie.id == self.movie!.id {
                            self.isFavorite = true
                        }
                    }
                    
                    performUIUpdatesOnMain {
                        if self.isFavorite {
                            self.toggleFavoriteButton.tintColor = nil
                        } else {
                            self.toggleFavoriteButton.tintColor = UIColor.blackColor()
                        }
                    }
                } else {
                    print(error)
                }
            }
            
            // Is movie on watchlist?
            TMDBClient.sharedInstance().getWatchlistMovies { (movies, error) in
                if let movies = movies {
                    
                    for movie in movies {
                        if movie.id == self.movie!.id {
                            self.isWatchlist = true
                        }
                    }
                    
                    performUIUpdatesOnMain {
                        if self.isWatchlist {
                            self.toggleWatchlistButton.tintColor = nil
                        } else {
                            self.toggleWatchlistButton.tintColor = UIColor.blackColor()
                        }
                    }
                } else {
                    print(error)
                }
            }
            
            // Set the poster image
            if let posterPath = movie.posterPath {
                TMDBClient.sharedInstance().taskForGETImage(TMDBClient.PosterSizes.DetailPoster, filePath: posterPath, completionHandlerForImage: { (imageData, error) in
                    if let image = UIImage(data: imageData!) {
                        performUIUpdatesOnMain {
                            self.activityIndicator.alpha = 0.0
                            self.activityIndicator.stopAnimating()
                            self.posterImageView.image = image
                        }
                    }
                })
            } else {
                activityIndicator.alpha = 0.0
                activityIndicator.stopAnimating()
            }
        }
    }
    // Actions
    
    @IBAction func toggleFavorite(sender: AnyObject) {

    }
    
    @IBAction func toggleWatchlist(sender: AnyObject) {

    }
}