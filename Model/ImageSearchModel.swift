//
//  ImageSearchModel.swift
//  FlickrCodeChallenge
//
//  Created by Abby Ke on 9/23/24.
//

import Foundation
import Combine

class ImageSearchModel: SearchModel{
    @Published var searchText: String = ""
    @Published var items: [FlickrImage] = []
}
