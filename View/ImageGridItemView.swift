//
//  ImageGridItemView.swift
//  FlickrCodeChallenge
//
//  Created by Abby Ke on 9/23/24.
//

import SwiftUI

struct ImageGridItemView: View {
    let item: FlickrImage
    
    var body: some View {
        VStack {
            if let imagePath = item.media?.imagePath, let url = URL(string: imagePath) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView().frame(width: 80, height: 80) // show progress view while still loading
                    case .success(let image):
                        image.resizable().scaledToFit().frame(width: 80, height: 80)
                    case .failure:
                        Image(systemName: "photo").resizable().scaledToFit().frame(width: 80, height: 80) // if fails, shows a photo logo as placeholder
                    @unknown default:
                        Image(systemName: "questionmark") // Missing Content or unexpected content
                    }
                }
            } else {
                Image(systemName: "photo").resizable().scaledToFit().frame(width: 80, height: 80).clipped()
            }
        }
    }
}

//#Preview {
//    ImageGridItemView()
//}
