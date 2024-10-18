//
//  Picture.swift
//  Mahlzeit
//
//  Created by Marcel Giovanni Munaba on 10.10.24.
//

import SwiftUI
import os

public struct Picture {
    private var imageName: String?
    var pictureData: Data?
    var logger = Logger()
    
    /// Initialiser
    /// Parameters:
    /// - pictureData: The picture's data which would be turned into Image
    /// - imageName: Image's String data
    public init(pictureData: Data?, imageName: String?) {
        // If pictureData is nil (happens on MockData), it will be initialised to Data()
        if pictureData == nil {
            self.pictureData = Data()
            self.imageName = imageName
        } else {
            self.pictureData = pictureData
            self.imageName = nil
        }
    }
    
    /// Gets the raw image from imageData / resource (imageName)
    /// Parameters: none
    /// Returns an Optional(Image) if the picture data could be transformed, nil otherwise
    public func getImage() -> Image? {
        if let data = pictureData, (imageName?.isEmpty) == nil {
            if let uiImage = UIImage(data: data) {
                return Image(uiImage: uiImage)
            } else {
                logger.log("Failed to create UIImage from data")
            }
        } else if (imageName?.isEmpty) != nil {
            return Image(imageName ?? "")
        }
        return nil
    }
    
    /// Sets the imageData of an instance
    /// Parameters:
    /// - imageData: The Data of an Image
    public mutating func setImage(imageData: Data) {
        pictureData = imageData
    }
}
