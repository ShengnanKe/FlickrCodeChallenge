//
//  JsonDecoder.swift
//  FlickrCodeChallenge
//
//  Created by Abby Ke on 9/23/24.
//

import Foundation

func jsonDecoder<T: Decodable>(data: Data) -> T? {
    let decoder = JSONDecoder()
    do {
        let decodedObject = try decoder.decode(T.self, from: data)
        return decodedObject
    } catch {
        print(Constants.ErrorMessages.FailToDecode)
        return nil
    }
}
