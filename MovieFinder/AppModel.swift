//
//  AppModel.swift
//  MovieFinder
//
//  Created by Vinay Desiraju on 3/24/23.
//

import Foundation
import UIKit

// The App model contains structs for different categories
// of movies and for the movie details like name, poster,
// rating, genre, release date and overview.

struct RequestTokenResponse: Codable {
    let success: Bool
    let expiresAt: String
    let requestToken: String

    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}

struct Result: Codable {
    var id : Int
    var title : String
    var posterPath: String
    var voteCount: Int
}

struct MoviePosters {
    var movieId : Int
    var moviewpos : UIImage
}

struct FavMovies : Codable {
    var results : [Result]
}

struct PopularMovie : Codable {
    var results : [Result]
}

struct NowPlayingMovies : Codable{
    var results : [Result]
}

struct TopRatedMovies : Codable{
    var results : [Result]
}

struct UpComingMovies : Codable{
    var results : [Result]
}

struct MovieDetails: Codable {
    var id: Int
    var title: String
    var voteAverage: Double
    var releaseDate: String
    var overview: String
    var genres: [Genre]
}

struct Genre : Codable {
    var id : Int
    var name : String
}

struct MovieImages {
    var movieImages : [UIImage]
}

struct ImagePaths : Codable {
    var id: Int
    var backdrops : [BackDropspaths]
}

struct BackDropspaths : Codable {
    var filePath : String
}

