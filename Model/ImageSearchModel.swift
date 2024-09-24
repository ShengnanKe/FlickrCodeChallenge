//
//  ImageSearchModel.swift
//  FlickrCodeChallenge
//
//  Created by Abby Ke on 9/23/24.
//

import Foundation
import Combine

class ImageSearchModel: SearchModel{
    @Published var searchText: String = ""  // current search text binding with searchable(search bar)
    @Published var items: [FlickrImage] = [] // array of FlickrImage: represent the search results from the API
}
