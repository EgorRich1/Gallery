//
//  ApiManager.swift
//  Gallery
//
//  Created by Егор Ярошук on 10.02.24.
//

import Foundation

fileprivate struct AuthModel: Encodable {
    let client_id: String
    let client_secret: String
    let redirect_uri: String
    
}

final class ApiManager {
    
    static let shared = ApiManager()
    
    func loadProtos(page: Int, completion: @escaping (Result<[ImageResponse], Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/photos?client_id=7qikvt3QELlk2-3pI8tyi86G1RnL-ABU9Ptluqlm5ZE&page=\(page)&per_page=30") else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(.failure(NSError(domain: error?.localizedDescription ?? "Error", code: -1)))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode([ImageResponse].self, from: data)
                completion(.success(result))
            }
            catch {
                completion(.failure(NSError(domain: error.localizedDescription, code: -1)))
            }
        }.resume()
    }
}
