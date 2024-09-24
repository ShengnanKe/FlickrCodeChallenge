//
//  ImageDetailView.swift
//  FlickrCodeChallenge
//
//  Created by Abby Ke on 9/23/24.
//

import SwiftUI

struct ImageDetailView: View {
    let item: FlickrImage
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imagePath = item.media?.imagePath, let url = URL(string: imagePath) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .background(Color.gray.opacity(0.1))
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .cornerRadius(8)
                                .shadow(radius: 4)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding(.bottom, 16)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .foregroundColor(.gray)
                        .padding(.bottom, 16)
                }
                
                // Title
                Text(item.title ?? "No Title")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.bottom, 4)
                
                // Author
                Text("By \(extractedAuthor(from: item.author))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 8)
                
                // Description
                Text(extractPlainText(from: item.description))
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.bottom, 12)
                
                // Published date
                Text("Published: \(formatDate(from: item.published))")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
            .navigationTitle("Image Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func formatDate(from dateString: String?) -> String {
        guard let dateString = dateString else { return "" }
        // print(dateString)
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        
        return ""
    }
    
    func extractedAuthor(from inputString: String?) -> String {
        guard let inputString = inputString else { return "" }
        //print(inputString)
        
        if let startRange = inputString.range(of: "("),
           let endRange = inputString.range(of: ")", range: startRange.upperBound..<inputString.endIndex) {
            let extractedText = inputString[startRange.upperBound..<endRange.lowerBound]
            return String(extractedText)
        }
        
        return ""
    }
    
    func extractPlainText(from html: String?) -> String {
        guard let html = html, let data = html.data(using: .utf8) else {
            print(Constants.ErrorMessages.htmlInvalid)
            return ""
        }
        print(html)

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributedString.string.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            print(Constants.ErrorMessages.FailToConvert)
            return ""
        }
    }
}


//#Preview {
//    ImageDetailView()
//}
