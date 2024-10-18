//
//  Error.swift
//  Mahlzeit
//
//  Created by Marcel Giovanni Munaba on 15.10.24.
//

enum CustomError: Error {
    /// Error types:
    /// - APIerror: Errors that relates to data fetching from the API, etc.
    /// - ImageError: Errror relating images, e.g. transformations from imageData to Image
    case APIerror
    case imageError
}
