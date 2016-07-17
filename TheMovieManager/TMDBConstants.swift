//
//  TMDBConstants.swift
//  TheMovieManager

// TMDBClient (Constants)

extension TMDBClient {
    
    // Constants
    struct Constants {
        
        // API Key
        static let ApiKey: String = "9e805dbbb2877cb4562ccb43a0a902bc"
                        
        // URLs
        static let ApiScheme = "https"
        static let ApiHost = "api.themoviedb.org"
        static let ApiPath = "/3"
        static let AuthorizationURL: String = "https://www.themoviedb.org/authenticate/"
    }
    
    // Methods
    struct Methods {
        
        // Account
        static let Account = "/account"
        static let AccountIDFavoriteMovies = "/account/{id}/favorite/movies"
        static let AccountIDFavorite = "/account/{id}/favorite"
        static let AccountIDWatchlistMovies = "/account/{id}/watchlist/movies"
        static let AccountIDWatchlist = "/account/{id}/watchlist"
        
        // Authentication
        static let AuthenticationTokenNew = "/authentication/token/new"
        static let AuthenticationSessionNew = "/authentication/session/new"
        
        // Search
        static let SearchMovie = "/search/movie"
        
        // Config
        static let Config = "/configuration"
        
    }

    // URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    // Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
    }
    
    // JSON Body Keys
    struct JSONBodyKeys {
        static let MediaType = "media_type"
        static let MediaID = "media_id"
        static let Favorite = "favorite"
        static let Watchlist = "watchlist"
    }

    // JSON Response Keys
    struct JSONResponseKeys {
      
        // General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // Authorization
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        
        // Account
        static let UserID = "id"
        
        // Config
        static let ConfigBaseImageURL = "base_url"
        static let ConfigSecureBaseImageURL = "secure_base_url"
        static let ConfigImages = "images"
        static let ConfigPosterSizes = "poster_sizes"
        static let ConfigProfileSizes = "profile_sizes"
        
        // Movies
        static let MovieID = "id"
        static let MovieTitle = "title"        
        static let MoviePosterPath = "poster_path"
        static let MovieReleaseDate = "release_date"
        static let MovieReleaseYear = "release_year"
        static let MovieResults = "results"
        
    }
    
    // Poster Sizes
    struct PosterSizes {
        static let RowPoster = TMDBClient.sharedInstance().config.posterSizes[2]
        static let DetailPoster = TMDBClient.sharedInstance().config.posterSizes[4]
    }
}