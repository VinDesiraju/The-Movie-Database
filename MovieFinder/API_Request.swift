//
//  API_Request.swift
//  MovieFinder
//
//  Created by Vinay Desiraju on 3/24/23.
//

import Foundation
import UIKit

// API_Request class uses the API token to make API requests.
class API_Request{
    // instance of class.
    static let shared = API_Request()
    // API beartoken.
    private let bearToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0MWYzNmViZjM1ZjM3YjlmYTgwYmQ3NjBjNzIyNzA5ZiIsInN1YiI6IjY0MWIyZGQ3ZDc1YmQ2MDBmNjljNjBkZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.y3-M2iHFva2MMucNAxV2pJNRwDPQulk1AdnLKhnaBIQ"
    
    func getAccountId(apiKey: String, sessionID: String, completion: @escaping (String?) -> Void){
        let accountURL = "https://api.themoviedb.org/3/account?api_key=\(apiKey)&session_id=\(sessionID)"
        let url = URL(string: accountURL)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let accountResponse = try decoder.decode(TMDbAccountResponse.self, from: data)
                
                let accountID = accountResponse.id
                print("Account ID: \(accountID)")
            } catch {
                print("Error decoding account response: \(error.localizedDescription)")
            }
        }
        
        
        task.resume()
    }
    func getRequestToken(apiKey: String, completion: @escaping (String?) -> Void) {
        let baseURL = "https://api.themoviedb.org/3/authentication/token/new"
        let urlString = "\(baseURL)?api_key=\(apiKey)"

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let tokenResponse = try decoder.decode(TMDbTokenResponse.self, from: data)

                let requestToken = tokenResponse.requestToken
                completion(requestToken)
            } catch {
                print("Error decoding token response: \(error.localizedDescription)")
                completion(nil)
            }
        }

        task.resume()
    }


//    func fetchRequestToken(completion: @escaping (String?) -> Void) {
//        let urlString = "https://api.themoviedb.org/3/authentication/token/new?api_key=41f36ebf35f37b9fa80bd760c722709f"
//        guard let url = URL(string: urlString) else {
//            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
//            completion(nil)
//            return
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("Bearer \(bearToken)", forHTTPHeaderField: "Authorization")
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(nil)
//                return
//            }
//            guard let data = data else {
//                let error = NSError(domain: "Invalid Data", code: 0, userInfo: nil)
//                completion(nil)
//                return
//            }
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let requestTokenResponse = try decoder.decode(RequestTokenResponse.self, from: data)
//                let requestToken = requestTokenResponse.requestToken
//                completion("success")
//            } catch {
//                completion(nil)
//            }
//        }
//        task.resume()
//    }

//    func createSession(with requestToken: String, username: String, password: String, completion: @escaping (String?) -> Void) {
//        let baseURL = "https://api.themoviedb.org/3/authentication/session/new"
//        guard let url = URL(string: baseURL) else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
//
//        let body: [String: Any] = [
//            "request_token": requestToken,
//            "username": username,
//            "password": password
//        ]
//
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else { return }
//
//        request.httpBody = httpBody
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard let data = data, error == nil else {
//                print("Error: \(error?.localizedDescription ?? "Unknown error")")
//                completion(nil)
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let sessionResponse = try decoder.decode(TMDbSessionResponse.self, from: data)
//
//                let sessionId = sessionResponse.sessionId
//                completion(sessionId)
//            } catch {
//                print("Error decoding session response: \(error.localizedDescription)")
//                completion(nil)
//            }
//        }.resume()
//    }
//
   //  Add a movie to the user's favorite list
    func addToFavorites(movieId: Int, sessionId: String, apiKey: String, completion: @escaping (Error?) -> Void) {
        let baseURL = "https://api.themoviedb.org/3/account/18478662/favorite"
        let urlString = "\(baseURL)?api_key=\(apiKey)&session_id=\(sessionId)"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let bodyDict: [String: Any] = ["media_type": "movie", "media_id": movieId, "favorite": true]
        let jsonData = try? JSONSerialization.data(withJSONObject: bodyDict)
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
        task.resume()
    }
    
    // Remove a movie from the user's favorite list
    func removeFromFavorites(movieId: Int, sessionId: String, apiKey: String, completion: @escaping (Error?) -> Void) {
        let baseURL = "https://api.themoviedb.org/3/account/18478662/favorite"
        let urlString = "\(baseURL)?api_key=\(apiKey)&session_id=\(sessionId)"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let bodyDict: [String: Any] = ["media_type": "movie", "media_id": movieId, "favorite": false]
        let jsonData = try? JSONSerialization.data(withJSONObject: bodyDict)
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
        task.resume()
    }


    // Fetch the user's favorite movies
    func fetchFavoriteMovies(completion: @escaping (FavMovies?, Error?) -> Void) {
        let sessionId = "a61697cabf65b0d199b64d9d08026bb10f6f6a87"
        let apiKey = "41f36ebf35f37b9fa80bd760c722709f"
        let baseURL = "https://api.themoviedb.org/3/account/18478662/favorite/movies"
        let urlString = "\(baseURL)?api_key=\(apiKey)&session_id=\(sessionId)"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(nil, error)
            return
        }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                let error = NSError(domain: "Invalid Data", code: 0, userInfo: nil)
                completion(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let favoriteMovies = try decoder.decode(FavMovies.self, from: data)
                completion(favoriteMovies, error)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }


//    func fetchFavoriteMovies(completion: @escaping (FavMovies?, Error?) -> Void) {
//        let baseURL = "https://api.themoviedb.org/3/account/18478662/favorite/movies"
//        let urlString = "\(baseURL)?api_key=9f3d1d2bbc80d51c5e319e3859324b746753444a&session_id=41f36ebf35f37b9fa80bd760c722709f"
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            return
//        }
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data else {
//                completion(nil, error)
//                return
//            }
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let response = try decoder.decode(FavMovies.self, from: data)
//                completion(response, nil)
//            } catch let error {
//                completion(nil, error)
//            }
//        }.resume()
//    }

//    // This function is used to download the image from url.
//    // Makes an API request to the url using the bearToken
    
    func checkIfMovieIsFavorited(movieId: Int, completion: @escaping (Bool?) -> Void) {
        let sessionId = "a61697cabf65b0d199b64d9d08026bb10f6f6a87"
        let apiKey = "41f36ebf35f37b9fa80bd760c722709f"
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/account_states?api_key=\(apiKey)&session_id=\(sessionId)"
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                if let json = jsonObject as? [String: Any],
                   let favorite = json["favorite"] as? Bool {
                    completion(favorite)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        task.resume()
    }

    func downloadImgfromURL(movieID : Int, posterPath: String, completion: @escaping(MoviePosters?) -> Void){
                
        let imageCache = NSCache<NSString,UIImage>()
        let imageURL = "https://image.tmdb.org/t/p/w500"
        guard let URL = URL(string: imageURL + posterPath ) else {return}
        var request = URLRequest(url: URL)
        request.addValue("Bearer \(bearToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.downloadTask(with: request){ URL, response, error in
            guard let URL = URL, error == nil else{
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                DispatchQueue.main.async{
                    if let data = try? Data(contentsOf: URL),
                    let image = UIImage(data: data){
                        imageCache.setObject(image, forKey: URL.absoluteString as NSString)
                        let moviePoster = MoviePosters(movieId: movieID, moviewpos: image)
                        completion(moviePoster)
                    }
                    else
                    {
                        completion(nil)
                    }
                }
            }
            
        }.resume()
    }
    
    // The following functions have similar functionality. They are used to fetch the data of movies
    // from different categories using the bearToken and respective URL's.
    // Proper error handling has also been done, in case of failure.
    
    func getPopularMovies(completion: @escaping(PopularMovie?) -> Void) {
        
        let baseURl = "https://api.themoviedb.org/3/movie/popular"
        guard let URL = URL(string: baseURl) else {return}
        var request = URLRequest(url: URL)
        request.addValue("Bearer \(bearToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
       URLSession.shared.dataTask(with: request){data, response, error in
            guard let data = data, error == nil else{
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let popularMovies = try decoder.decode(PopularMovie.self, from: data)
                completion(popularMovies)
            }catch{
                print("Error decoding movie: \(error.localizedDescription)")
                completion(nil)
            }
       }.resume()
    }
    
    func getNowPlayingMovies(completion: @escaping(NowPlayingMovies?) -> Void){
        
        let nowPlayingMoviesURL = "https://api.themoviedb.org/3/movie/now_playing"
        guard let URL = URL(string: nowPlayingMoviesURL) else{return}
        var request = URLRequest(url: URL)
        request.addValue("Bearer \(bearToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data = data, error == nil else{
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else
            {
                print("Error: Invalid response")
                completion(nil)
                return
            }
            print("HTTP Status Code for now playing: \(httpResponse.statusCode)")
            
            do
            {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let nowPlayingMovies = try decoder.decode(NowPlayingMovies.self, from: data)
                completion(nowPlayingMovies)
            }catch{
                print("Error decoding nowplayingmovie: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    func getUpcomingMovies(completion: @escaping(UpComingMovies?) -> Void){
        
        let upcomingMoviesURL = "https://api.themoviedb.org/3/movie/upcoming"
        guard let URL = URL(string: upcomingMoviesURL) else{return}
        var request = URLRequest(url: URL)
        request.addValue("Bearer \(bearToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data = data, error == nil else{
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else
            {
                print("Error: Invalid response")
                completion(nil)
                return
            }
            print("HTTP Status Code for upcoming movie: \(httpResponse.statusCode)")
            
            do
            {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let upComingMovies = try decoder.decode(UpComingMovies.self, from: data)
                completion(upComingMovies)
            }catch{
                print("Error decoding upcoming movie: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    func getTopRatedMovies(completion: @escaping(TopRatedMovies?) -> Void){
        
        let topRatedMoviesURL = "https://api.themoviedb.org/3/movie/top_rated"
        guard let URL = URL(string: topRatedMoviesURL) else{return}
        var request = URLRequest(url: URL)
        request.addValue("Bearer \(bearToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data = data, error == nil else{
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else
            {
                print("Error: Invalid response")
                completion(nil)
                return
            }
            print("HTTP Status Code for Top Rated Movies: \(httpResponse.statusCode)")
            
            do
            {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let topRatedMovies = try decoder.decode(TopRatedMovies.self, from: data)
                completion(topRatedMovies)
            }catch{
                print("Error decoding TopRatedmovie: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    func getMovieDetails(movieID: Int, completion: @escaping(MovieDetails?) -> Void){
        
        let detailsURL = "https://api.themoviedb.org/3/movie/\(movieID)"
        
        guard let URL = URL(string: detailsURL) else{return}
        var request = URLRequest(url : URL)
        request.addValue("Bearer \(bearToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            do
            {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movieDetails = try decoder.decode(MovieDetails.self, from: data)
                // Retrieved MovieDetails
                completion(movieDetails)
            }catch{
                print("Error decoding Movie Details: \(error.localizedDescription)")
                completion(nil)
            }
            
        }.resume()
        
    }
    
    
    // This function is used to get the movie Image BackPaths
    func getMovieImageBackPaths(movieID: Int, completion: @escaping(ImagePaths?) -> Void){
        
        let pathsUrl = "https://api.themoviedb.org/3/movie/\(movieID)/images"
        guard let url = URL(string: pathsUrl) else {return}
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(bearToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            do
            {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let imagePaths = try decoder.decode(ImagePaths.self, from: data)
                // Retrieved MovieDetails
                completion(imagePaths)
            }catch{
                print("Error decoding Movie Image Backpaths: \(error.localizedDescription)")
                completion(nil)
            }
            
        }.resume()
    
    }
    
    // This function is used  to download the movie image.
    func downloadMovieImage(imgPaths: ImagePaths , completion: @escaping(MovieImages?) -> Void){
        
        let imageURL = "https://image.tmdb.org/t/p/w500"
        var movieImages = Array<UIImage>()
        let group = DispatchGroup()
        
            for path in imgPaths.backdrops{
                group.enter()
                let imageCache = NSCache<NSString,UIImage>()
                guard let URL = URL(string: imageURL + path.filePath ) else {return}
                
                var request = URLRequest(url: URL)
                request.addValue("Bearer \(self.bearToken)", forHTTPHeaderField: "Authorization")
                request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
                
                URLSession.shared.downloadTask(with: request){ url, response, error in
                    guard let url = url, error == nil else{
                        print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        completion(nil)
                        return
                    }
                    do{
                        if let data = try? Data(contentsOf: url),
                        let image = UIImage(data: data){
                            imageCache.setObject(image, forKey: URL.absoluteString as NSString)
                            movieImages.append(image)
                            group.leave()
                        }
                        else{
                            debugPrint("failed to download movie images")
                            completion(nil)
                        }
                    }
                    
                }.resume()
                
            }
            group.notify(queue: DispatchQueue.main){
                let movieImages = MovieImages(movieImages: movieImages)
                debugPrint("All movie images downloaded")
                completion(movieImages)
            }
        }
}

