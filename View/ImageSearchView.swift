//
//  ImageSearchView.swift
//  FlickrCodeChallenge
//
//  Created by Abby Ke on 9/23/24.
//

import SwiftUI

// The main view for searching and displaying search results from Flickr
struct ImageSearchView: View {
    @StateObject private var container: SearchContainer<ImageSearchModel, ImageSearchIntent>
    
    init() {
        let model = ImageSearchModel()
        let intent = ImageSearchIntent(model: model)
        _container = StateObject(wrappedValue: SearchContainer(model: model, intent: intent))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ScrollView {
                        // Display the search results with customized ImageGridItemView
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                            ForEach(container.model.items, id: \.self) { item in
                                NavigationLink {
                                    ImageDetailView(item: item)
                                } label: {
                                    ImageGridItemView(item: item)
                                }
                            }
                        }
                        .padding()
                    }
                    // update the search text accordingly in the model based on the content received in the Search bar
                    .searchable(text: Binding(get: {
                        container.model.searchText
                    }, set: { container.intent.updateSearchText($0)
                    }), prompt: "Search Images ...")
                    .onSubmit {
                        container.intent.searchImage() // Triggers API search when the user submits
                    }
                    .onChange(of: container.model.searchText) { (oldValue, newValue) in
                        // trigger a new search or clear items when the search text changes
                        if newValue != "" {
                            container.intent.searchImage()
                        } else {
                            container.model.items = []
                        }
                    }
                }
                
                // an overall progressor view
                if container.model.isLoading {
                    ProgressView("Searching...").padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.3))
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .navigationTitle("Search for Images")
        }
    }
}


//#Preview {
//    ImageSearchView()
//}
