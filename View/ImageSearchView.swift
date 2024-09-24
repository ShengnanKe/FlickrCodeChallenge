//
//  ImageSearchView.swift
//  FlickrCodeChallenge
//
//  Created by Abby Ke on 9/23/24.
//

import SwiftUI

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
                    .searchable(text: Binding(get: {
                        container.model.searchText
                    }, set: { container.intent.updateSearchText($0)
                    }), prompt: "Search Images ...")
                    .onSubmit {
                        container.intent.searchImage()
                    }
                    .onChange(of: container.model.searchText) { (oldValue, newValue) in
                        if newValue != "" {
                            container.intent.searchImage()
                        } else {
                            container.model.items = []
                        }
                    }
                }
                
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
