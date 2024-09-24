//
//  Constant.swift
//  FlickrCodeChallenge
//
//  Created by KKNANXX on 9/23/24.
//

import Foundation

struct Constants {
    // Flicker API URL https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=porcupine
    static let flickrBaseURL = "https://api.flickr.com/services/feeds/photos_public.gne"
    
    struct APIParameters {
        static let format = "json"
        static let noJSONCallback = "1"
    }

    // API Headers
    struct APIHeaders {
        static let contentType = "application/json"
    }
    
    struct ErrorMessages {
        static let badURL = "The URL is invalid."
        static let requestFailed = "Network request failed. Please try again."
        static let htmlInvalid = "HTML input is nil or failed to convert."
        static let FailToConvert = "Failed to convert Data to NSAttributedString."
        static let FailToDecode = "Failed to decode JSON."
        static let FailToConvertImage = "Failed to convert Data to Image."
        static let FailToDownloadImage = "Failed to Download Image."
    }
}
