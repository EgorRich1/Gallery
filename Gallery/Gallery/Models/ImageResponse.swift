//
//  ImageResponse.swift
//  Gallery
//
//  Created by Егор Ярошук on 11.02.24.
//

import Foundation

struct ImageResponse: Decodable {
    let id: String
    let description: String?
    let altDescription: String
    let urls: Urls
    var isLiked: Bool?
    
    struct Urls: Decodable {
        let thumb: String
        let full: String
    }
}
