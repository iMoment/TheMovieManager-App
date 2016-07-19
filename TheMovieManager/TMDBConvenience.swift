//
//  TMDBConvenience.swift
//  TheMovieManager

import UIKit
import Foundation

// TMDBClient (Convenient Resource Methods)

extension TMDBClient {
    
    func authenticateWithViewController(hostViewController: UIViewController, completionHandlerForAuth: (success: Bool, errorString: String?) -> Void) {
        
        // Chain completion handlers for each request so that they run one after the other
        getRequestToken() { (success, requestToken, errorString) in
            
            if success {
                
                // Success! We have the requestToken!
                print(requestToken)
                self.requestToken = requestToken
                
                self.loginWithToken(requestToken, hostViewController: hostViewController) { (success, errorString) in
                    
                    if success {
                        self.getSessionID(requestToken) { (success, sessionID, errorString) in
                            
                            if success {
                                
                                // Success! We have the sessionID!
                                self.sessionID = sessionID
                                
                                self.getUserID() { (success, userID, errorString) in
                                    
                                    if success {
                                        
                                        if let userID = userID {
                                            
                                            // And the userID 😄!
                                            self.userID = userID
                                        }
                                    }
                                    
                                    completionHandlerForAuth(success: success, errorString: errorString)
                                }
                            } else {
                                completionHandlerForAuth(success: success, errorString: errorString)
                            }
                        }
                    } else {
                        completionHandlerForAuth(success: success, errorString: errorString)
                    }
                }
            } else {
                completionHandlerForAuth(success: success, errorString: errorString)
            }
        }
    }
    
    private func getRequestToken(completionHandlerForToken: (success: Bool, requestToken: String?, errorString: String?) -> Void) {
        
        // Set parameters
        let parameters = [String:AnyObject]()
        
        // Make request
        taskForGETMethod(Methods.AuthenticationTokenNew, parameters: parameters) { (results, error) in
            
            if let error = error {
                print(error)
                completionHandlerForToken(success: false, requestToken: nil, errorString: "Login Failed. (Request Token)")
            } else {
                if let requestToken = results[TMDBClient.JSONResponseKeys.RequestToken] as? String {
                    completionHandlerForToken(success: true, requestToken: requestToken, errorString: nil)
                } else {
                    print("Could not find \(TMDBClient.JSONResponseKeys.RequestToken) in \(results)")
                    completionHandlerForToken(success: false, requestToken: nil, errorString: "Login Failed. (Request Token)")
                }
            }
        }
    }
    
    private func loginWithToken(requestToken: String?, hostViewController: UIViewController, completionHandlerForLogin: (success: Bool, errorString: String?) -> Void) {
        
        let authorizationURL = NSURL(string: "\(TMDBClient.Constants.AuthorizationURL)\(requestToken!)")
        let request = NSURLRequest(URL: authorizationURL!)
        let webAuthViewController = hostViewController.storyboard!.instantiateViewControllerWithIdentifier("TMDBAuthViewController") as! TMDBAuthViewController
        webAuthViewController.urlRequest = request
        webAuthViewController.requestToken = requestToken
        webAuthViewController.completionHandlerForView = completionHandlerForLogin
        
        let webAuthNavigationController = UINavigationController()
        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
        
        performUIUpdatesOnMain {
            hostViewController.presentViewController(webAuthNavigationController, animated: true, completion: nil)
        }
    }
    
    private func getSessionID(requestToken: String?, completionHandlerForSession: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
        
        // Set parameters
        let parameters = [TMDBClient.ParameterKeys.RequestToken : requestToken!]
        
        // Make the request
        taskForGETMethod(Methods.AuthenticationSessionNew, parameters: parameters) { (results, error) in
            
            if let error = error {
                print(error)
                completionHandlerForSession(success: false, sessionID: nil, errorString: "Login Failed. (Session ID)")
            } else {
                if let sessionID = results[TMDBClient.JSONResponseKeys.SessionID] as? String {
                    completionHandlerForSession(success: true, sessionID: sessionID, errorString: nil)
                } else {
                    print("Could not find \(TMDBClient.JSONResponseKeys.SessionID) in \(results)")
                    completionHandlerForSession(success: false, sessionID: nil, errorString: "Login Failed. (Session ID)")
                }
            }
        }
    }
    
    private func getUserID(completionHandlerForUserID: (success: Bool, userID: Int?, errorString: String?) -> Void) {
        
        // Set parameters
        let parameters = [TMDBClient.ParameterKeys.SessionID : TMDBClient.sharedInstance().sessionID!]
        
        // Make the request
        taskForGETMethod(Methods.Account, parameters: parameters) { (results, error) in
            
            if let error = error {
                print(error)
                completionHandlerForUserID(success: false, userID: nil, errorString: "Login Failed. (User ID)")
            } else {
                if let userID = results[TMDBClient.JSONResponseKeys.UserID] as? Int {
                    completionHandlerForUserID(success: true, userID: userID, errorString: nil)
                } else {
                    print("Could not find \(TMDBClient.JSONResponseKeys.UserID) in \(results)")
                    completionHandlerForUserID(success: false, userID: nil, errorString: "Login Failed. (User ID)")
                }
            }
        }
      
    }
    
    // GET Convenience Methods
    
    func getFavoriteMovies(completionHandlerForFavMovies: (result: [TMDBMovie]?, error: NSError?) -> Void) {
        
        // Set parameters
        let parameters = [TMDBClient.ParameterKeys.SessionID : TMDBClient.sharedInstance().sessionID!]
        var mutableMethod: String = Methods.AccountIDFavoriteMovies
        mutableMethod = subtituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.UserID, value: String(TMDBClient.sharedInstance().userID!))!
        
        // Make the request
        taskForGETMethod(mutableMethod, parameters: parameters) { (results, error) in
            
            if let error = error {
                completionHandlerForFavMovies(result: nil, error: error)
            } else {
                if let results = results[TMDBClient.JSONResponseKeys.MovieResults] as? [[String : AnyObject]] {
                    let movies = TMDBMovie.moviesFromResults(results)
                    completionHandlerForFavMovies(result: movies, error: nil)
                } else {
                    completionHandlerForFavMovies(result: nil, error: NSError(domain: "getFavoriteMovies", code: 1, userInfo: [NSLocalizedDescriptionKey : "Could not parse getFavoriteMovies"]))
                }
            }
        }
    }
    
    func getWatchlistMovies(completionHandlerForWatchlist: (result: [TMDBMovie]?, error: NSError?) -> Void) {
        
        // Set parameters
        let parameters = [TMDBClient.ParameterKeys.SessionID : TMDBClient.sharedInstance().sessionID!]
        var mutableMethod: String = Methods.AccountIDWatchlistMovies
        mutableMethod = subtituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.UserID, value: String(TMDBClient.sharedInstance().userID!))!
        
        // Make the request
        taskForGETMethod(mutableMethod, parameters: parameters) { (results, error) in
            
            if let error = error {
                completionHandlerForWatchlist(result: nil, error: error)
            } else {
                if let results = results[TMDBClient.JSONResponseKeys.MovieResults] as? [[String : AnyObject]] {
                    let movies = TMDBMovie.moviesFromResults(results)
                    completionHandlerForWatchlist(result: movies, error: nil)
                } else {
                    completionHandlerForWatchlist(result: nil, error: NSError(domain: "getWatchlistMovies", code: 1, userInfo: [NSLocalizedDescriptionKey : "Could not parse getWatchlistMovies"]))
                }
            }
        }
    }
    
    func getMoviesForSearchString(searchString: String, completionHandlerForMovies: (result: [TMDBMovie]?, error: NSError?) -> Void) -> NSURLSessionDataTask? {
        
        // Set parameters
        let parameters = [TMDBClient.ParameterKeys.Query : searchString]
        
        // Make the request
        let task = taskForGETMethod(Methods.SearchMovie, parameters: parameters) { (results, error) in
            
            if let error = error {
                completionHandlerForMovies(result: nil, error: error)
            } else {
                if let results = results[TMDBClient.JSONResponseKeys.MovieResults] as? [[String : AnyObject]] {
                    let movies = TMDBMovie.moviesFromResults(results)
                    completionHandlerForMovies(result: movies, error: nil)
                } else {
                    completionHandlerForMovies(result: nil, error: NSError(domain: "getMoviesForSearchString", code: 1, userInfo: [NSLocalizedDescriptionKey : "Could not parse getMoviesForSearchString"]))
                }
            }
        }
        return task
    }
    
    func getConfig(completionHandlerForConfig: (didSucceed: Bool, error: NSError?) -> Void) {
        
        // Set parameters
        let parameters = [String : AnyObject]()
        
        // Make the request
        taskForGETMethod(Methods.Config, parameters: parameters) { (results, error) in
            
            if let error = error {
                completionHandlerForConfig(didSucceed: false, error: error)
            } else if let newConfig = TMDBConfig(dictionary: results as! [String : AnyObject]) {
                self.config = newConfig
                completionHandlerForConfig(didSucceed: true, error: nil)
            } else {
                completionHandlerForConfig(didSucceed: false, error: NSError(domain: "getConfig", code: 1, userInfo: [NSLocalizedDescriptionKey : "Could not parse getConfig"]))
            }
        }
    }
    
    // POST Convenience Methods
    
    func postToFavorites(movie: TMDBMovie, favorite: Bool, completionHandlerForFavorite: (result: Int?, error: NSError?) -> Void)  {
        
        // Set parameters
        let parameters = [TMDBClient.ParameterKeys.SessionID : TMDBClient.sharedInstance().sessionID!]
        var mutableMethod: String = Methods.AccountIDFavorite
        mutableMethod = subtituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.UserID, value: String(TMDBClient.sharedInstance().userID!))!
        let jsonBody = "{\"\(TMDBClient.JSONBodyKeys.MediaType)\": \"movie\",\"\(TMDBClient.JSONBodyKeys.MediaID)\": \"\(movie.id)\",\"\(TMDBClient.JSONBodyKeys.Favorite)\": \(favorite)}"
        
        // Make the request
        taskForPOSTMethod(mutableMethod, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                completionHandlerForFavorite(result: nil, error: error)
            } else {
                if let results = results[TMDBClient.JSONResponseKeys.StatusCode] as? Int {
                    completionHandlerForFavorite(result: results, error: nil)
                } else {
                    completionHandlerForFavorite(result: nil, error: NSError(domain: "postToFavorites", code: 1, userInfo: [NSLocalizedDescriptionKey : "Could not parse postToFavorites"]))
                }
            }
        }
    }
    
    func postToWatchlist(movie: TMDBMovie, watchlist: Bool, completionHandlerForWatchlist: (result: Int?, error: NSError?) -> Void) {
        
        // Set parameters
        let parameters = [TMDBClient.ParameterKeys.SessionID : TMDBClient.sharedInstance().sessionID!]
        var mutableMethod: String = Methods.AccountIDWatchlist
        mutableMethod = subtituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.UserID, value: String(TMDBClient.sharedInstance().userID!))!
        let jsonBody = "{\"\(TMDBClient.JSONBodyKeys.MediaType)\": \"movie\",\"\(TMDBClient.JSONBodyKeys.MediaID)\": \"\(movie.id)\",\"\(TMDBClient.JSONBodyKeys.Watchlist)\": \(watchlist)}"

        // Make the request
        taskForPOSTMethod(mutableMethod, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                completionHandlerForWatchlist(result: nil, error: error)
            } else {
                if let results = results[TMDBClient.JSONResponseKeys.StatusCode] as? Int {
                    completionHandlerForWatchlist(result: results, error: nil)
                } else {
                    completionHandlerForWatchlist(result: nil, error: NSError(domain: "postToWatchlist", code: 1, userInfo: [NSLocalizedDescriptionKey : "Could not parse postToWatchlist"]))
                }
            }
        }
    }
}