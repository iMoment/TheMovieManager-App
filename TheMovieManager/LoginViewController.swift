//
//  LoginViewController.swift
//  TheMovieManager

import UIKit

// LoginViewController: UIViewController

class LoginViewController: UIViewController {

    // Properties
    
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var loginButton: BorderedButton!

    var tmdbClient: TMDBClient!
    
    // Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the TMDB client
        tmdbClient = TMDBClient.sharedInstance()
        
        configureBackground()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        debugTextLabel.text = ""
    }
    
    // Actions
    
    @IBAction func loginPressed(sender: AnyObject) {
      
        TMDBClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
            performUIUpdatesOnMain {
                success ? self.completeLogin() : self.displayError(errorString)
            }
        }
    }
    
    // Login
    
    private func completeLogin() {
        debugTextLabel.text = ""
        let controller = storyboard!.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UINavigationController
        presentViewController(controller, animated: true, completion: nil)
    }
}

// LoginViewController (Configure UI)

extension LoginViewController {
    
    private func setUIEnabled(enabled: Bool) {
        loginButton.enabled = enabled
        debugTextLabel.enabled = enabled
        
        enabled ? (loginButton.alpha = 1.0) : (loginButton.alpha = 0.5)
    }
    
    private func displayError(errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }
    
    private func configureBackground() {
        let backgroundGradient = CAGradientLayer()
        let colorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).CGColor
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, atIndex: 0)
    }
}