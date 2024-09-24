//
//  SearchModel.swift
//  FlickrCodeChallenge
//
//  Created by Abby Ke on 9/23/24.
//

import Foundation

class SearchModel: ObservableObject {
    @Published var isLoading: Bool = false // whenever loading data from the API
    @Published var errorMessage: String? = nil
}
