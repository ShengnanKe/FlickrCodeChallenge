//
//  FlickrResponse.swift
//  FlickrCodeChallenge
//
//  Created by Abby Ke on 9/23/24.
//

import Foundation

// For parsing the Json content received from the API with Codable and Hashable protocol
struct FlickrResponse: Codable {
    let items: [FlickrImage]?
}

struct FlickrImage: Codable, Hashable {
    let title: String?
    let media: Media?
    let description: String?
    let author: String?
    let published: String?

    enum CodingKeys: String, CodingKey {
        case title
        case media
        case description
        case author
        case published
    }
}

struct Media: Codable, Hashable {
    let imagePath: String?

    enum CodingKeys: String, CodingKey { // coding key is needed for this specific link for loading the image
        case imagePath = "m"
    }
}
