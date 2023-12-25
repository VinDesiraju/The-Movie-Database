//
//  AuthManager.swift
//  MovieFinder
//
//  Created by Vinay Desiraju on 4/14/23.
//


import UIKit
import Foundation

class AuthManager {
    let apiKey: String
    var requestToken: String?
    var sessionId: String?
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func authenticate(completion: @escaping (Error?) -> Void) {
        // Step 1: Request a new token
        let tokenUrl = "https://api.themoviedb.org/3/authentication/token/new?api_key=\(apiKey)"
        guard let tokenRequestUrl = URL(string: tokenUrl) else {
            completion(NSError(domain: "TMDbSession", code: -1, userInfo: ["message": "Invalid URL"]))
            return
        }
        
        URLSession.shared.dataTask(with: tokenRequestUrl) { data, response, error in
            guard let data = data else {
                completion(error ?? NSError(domain: "TMDbSession", code: -1, userInfo: ["message": "Unknown error"]))
                return
            }
            
            do {
                let tokenResponse = try JSONDecoder().decode(TMDbTokenResponse.self, from: data)
                self.requestToken = tokenResponse.requestToken
                
                // Step 2: Ask the user to authorize the token
                let authUrl = "https://www.themoviedb.org/authenticate/\(tokenResponse.requestToken)?redirect_to=tmdbauth://authorize"
                if let authRequestUrl = URL(string: authUrl), UIApplication.shared.canOpenURL(authRequestUrl) {
                    UIApplication.shared.open(authRequestUrl)
                } else {
                    completion(NSError(domain: "TMDbSession", code: -1, userInfo: ["message": "Could not open authorization URL"]))
                    return
                }
                
                // Step 3: Wait for the user to authorize the token and request a new session
                NotificationCenter.default.addObserver(forName: Notification.Name("TMDbAuthDidAuthorize"), object: nil, queue: nil) { _ in
                    let sessionUrl = "https://api.themoviedb.org/3/authentication/session/new?api_key=\(self.apiKey)&request_token=\(tokenResponse.requestToken)"
                    guard let sessionRequestUrl = URL(string: sessionUrl) else {
                        completion(NSError(domain: "TMDbSession", code: -1, userInfo: ["message": "Invalid URL"]))
                        return
                    }
                    
                    URLSession.shared.dataTask(with: sessionRequestUrl) { data, response, error in
                        guard let data = data else {
                            completion(error ?? NSError(domain: "TMDbSession", code: -1, userInfo: ["message": "Unknown error"]))
                            return
                        }
                        
                        do {
                            let sessionResponse = try JSONDecoder().decode(TMDbSessionResponse.self, from: data)
                            self.sessionId = sessionResponse.sessionId
                            completion(nil)
                        } catch {
                            completion(error)
                        }
                    }.resume()
                }
            } catch {
                completion(error)
            }
        }.resume()
    }
}

struct TMDbTokenResponse: Codable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}

struct TMDbSessionResponse: Codable {
    let success: Bool
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case sessionId = "session_id"
    }
}
