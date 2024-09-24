//
//  FlickrCodeChallengeTests.swift
//  FlickrCodeChallengeTests
//
//  Created by Abby Ke on 9/23/24.
//

import XCTest
@testable import FlickrCodeChallenge

final class FlickrCodeChallengeTests: XCTestCase {
    
    var httpClient: HttpClient!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        httpClient = HttpClient()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        httpClient = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDownloadImageSuccess() async throws {
        // Correct URL
        let validURL = URL(string: "https://live.staticflickr.com/65535/53950549389_0a48188eb7_m.jpg")!
        
        let image = await httpClient.downloadImage(from: validURL)
        XCTAssertNotNil(image, "Image should not be nil on successful download")
    }
    
    func testDownloadImageFailure() async throws {
        let invalidURL = URL(string: "https://invalid.url/sample_image.jpg")!
        
        // Await the async function and assert the result
        let image = await httpClient.downloadImage(from: invalidURL)
        XCTAssertNil(image, "Image should be nil on download failure")
    }
    
    func testStripHTMLTags() {
        let htmlString = "<p>This is a <b>bold</b> text.</p>"
        
        let mockImage = FlickrImage(
            title: "Mock Title",
            media: Media(imagePath: "https://mock.image.url"),
            description: htmlString,
            author: "nobody@flickr.com (\"Mock Author\")",
            published: "2024-08-26T22:11:41Z"
        )
        
        let detailView = ImageDetailView(item: mockImage)
        
        let result = detailView.extractPlainText(from: htmlString)
        XCTAssertEqual(result, "This is a bold text.", "HTML tags should be stripped correctly")
    }

    
    func testFormattedDate() {
        let dateString = "2024-08-26T22:11:41Z"
        
        // Create a mock FlickrImage to use with ImageDetailView
        let mockImage = FlickrImage(
            title: "Mock Title",
            media: Media(imagePath: "https://mock.image.url"), // Correctly use Media structure
            description: "<p>Mock Description</p>",
            author: "nobody@flickr.com (\"Mock Author\")",
            published: dateString
        )
        
        // Initialize ImageDetailView with the mock data
        let detailView = ImageDetailView(item: mockImage)
        
        // Test formatDate function
        let result = detailView.formatDate(from: dateString)
        XCTAssertEqual(result, "2024-08-26", "Date should be formatted correctly") // Ensure expected format matches your function's output
    }

}
