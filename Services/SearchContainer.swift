//
//  SearchContainer.swift
//  FlickrCodeChallenge
//
//  Created by Abby Ke on 9/23/24.
//

import Foundation
import Combine

class SearchContainer<Model: SearchModel & ObservableObject, Intent: SearchIntent>: ObservableObject where Intent.ModelType == Model {
    @Published var model: Model
    var intent: Intent
    private var cancellables: Set<AnyCancellable> = []
    
    init(model: Model, intent: Intent) {
        self.model = model
        self.intent = intent
        
        // Listen to model changes and propagate them
        model.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
