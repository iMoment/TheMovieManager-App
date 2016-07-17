//
//  TMDBMovie.swift
//  TheMovieManager

// TMDBMovie

struct TMDBMovie {

    // Properties
    
    let title: String
    let id: Int
    let posterPath: String?
    let releaseYear: String?
    
    // Initializers
    
    // Construct a TMDBMovie from a dictionary
    init(dictionary: [String:AnyObject]) {        
        title = dictionary[TMDBClient.JSONResponseKeys.MovieTitle] as! String
        id = dictionary[TMDBClient.JSONResponseKeys.MovieID] as! Int
        posterPath = dictionary[TMDBClient.JSONResponseKeys.MoviePosterPath] as? String
        
        if let releaseDateString = dictionary[TMDBClient.JSONResponseKeys.MovieReleaseDate] as? String where releaseDateString.isEmpty == false {
            releaseYear = releaseDateString.substringToIndex(releaseDateString.startIndex.advancedBy(4))
        } else {
            releaseYear = ""
        }
    }
    
    static func moviesFromResults(results: [[String:AnyObject]]) -> [TMDBMovie] {
        
        var movies = [TMDBMovie]()
        
        // Iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            movies.append(TMDBMovie(dictionary: result))
        }
        
        return movies
    }
}

// TMDBMovie: Equatable

extension TMDBMovie: Equatable {}

func ==(lhs: TMDBMovie, rhs: TMDBMovie) -> Bool {
    return lhs.id == rhs.id
}