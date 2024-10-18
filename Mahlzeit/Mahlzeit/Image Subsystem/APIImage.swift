//
//  APIImage.swift
//  Mahlzeit
//
//  Created by Marcel Giovanni Munaba on 12.10.24.
//

import SwiftUI
import os

public struct APIImage {
    var url: String
    var imageData: Data?
    var image: Image?
    var logger: Logger
    
    /// Initialiser
    /// Parameters:
    /// - url: The URL string for the image
    public init(url: String) {
        self.url = url
        self.logger = Logger()
    }
    
    /// Fetches an image's data from a given link
    public mutating func fetchImageData(completion: @escaping (Data?, Image?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil, nil)
            return
        }
        
        let logger = self.logger
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                logger.log("Error fetching image: \(String(describing: error))")
                completion(nil, nil)
                return
            }

            let image = UIImage(data: data).flatMap { Image(uiImage: $0) }
            completion(data, image)
        }
        .resume()
    }
}
