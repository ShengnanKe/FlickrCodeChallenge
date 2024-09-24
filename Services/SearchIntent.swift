//
//  SearchIntent.swift
//  FlickrCodeChallenge
//
//  Created by Abby Ke on 9/23/24.
//

import Foundation
import Combine

protocol SearchIntent { 
    associatedtype ModelType: SearchModel
    var model: ModelType { get set }
}
