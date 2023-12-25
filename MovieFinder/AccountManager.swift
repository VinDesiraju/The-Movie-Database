//
//  AccountManager.swift
//  MovieFinder
//
//  Created by Vinay Desiraju on 4/14/23.
//

import Foundation

class AccountManager {
    let apiKey: String
    let sessionId: String
    var accountId: Int?
    
    init(apiKey: String, sessionId: String) {
        self.apiKey = apiKey
        self.sessionId = sessionId
    }
    
    func fetchAccountId(completion: @escaping (Error?) -> Void) {
        let accountUrl = "https://api.themoviedb.org/3/account?api_key=\(apiKey)&session_id=\(sessionId)"
        guard let accountRequestUrl = URL(string: accountUrl) else {
            completion(NSError(domain: "TMDbSession", code: -1, userInfo: ["message": "Invalid URL"]))
            return
        }
        
        URLSession.shared.dataTask(with: accountRequestUrl) { data, response, error in
            guard let data = data else {
                completion(error ?? NSError(domain: "TMDbSession", code: -1, userInfo: ["message": "Unknown error"]))
                return
            }
            
            do {
                let accountResponse = try JSONDecoder().decode(TMDbAccountResponse.self, from: data)
                self.accountId = accountResponse.id
                completion(nil)
            } catch {
                completion(error)
            }
        }.resume()
    }
}

struct TMDbAccountResponse: Decodable {
    let id: Int
}
