//
//  ImageSearchIntent.swift
//  FlickrCodeChallenge
//
//  Created by Abby Ke on 9/23/24.
//

import Foundation
import Combine

// the business logic: building the connection between the model and the view
// take userinput and update the model state
class ImageSearchIntent: SearchIntent {
    typealias ModelType = ImageSearchModel
    var model: ImageSearchModel
    private var cancellables = Set<AnyCancellable>()
    
    init(model: ImageSearchModel) {
        self.model = model
    }
    
    func updateSearchText(_ newText: String) {
        let cleanedText = cleanSearchText(newText)
        self.model.searchText = cleanedText
    }
    
    // Where the API request is actually triggered and activated, Updates the states in the model based on the result.
    func searchImage() {
        let httpClient = HttpClient()
        model.isLoading = true // when searching starts: indicator for the progressor view
        let requestBuilder = FlickrRequestBuilder(tags: [model.searchText])
        
        httpClient.fetch(requestBuilder: requestBuilder)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(Constants.ErrorMessages.requestFailed)
                    self.model.isLoading = false
                case .finished:
                    self.model.isLoading = false
                    break
                }
            }, receiveValue: { [weak self] (response: FlickrResponse) in
                // using weak self for avoiding retain cycle
                // updating model
                if let items = response.items {
                    self?.model.items = items
                } else {
                    self?.model.items = []
                }
            })
            .store(in: &cancellables)
    }
    
    // remove spaces after comma with regular expression
    private func cleanSearchText(_ input: String) -> String {
        let cleaned = input.replacingOccurrences(of: "\\s*,\\s*", with: ",", options: .regularExpression)
        return cleaned
    }
    
    
}

