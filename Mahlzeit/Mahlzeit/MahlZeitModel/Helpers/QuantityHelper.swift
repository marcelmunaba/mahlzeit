//
//  QuantityHelper.swift
//  Mahlzeit
//
//  Created by Marcel Giovanni Munaba on 12.10.24.
//

import Foundation

struct QuantityHelper {
    // Function to check if the string contains a fraction
    static func containsFraction(_ string: String) -> Bool {
        // Regular expression pattern for fractions and mixed numbers
        let fractionPattern = #"(?:(\d+)\s+)?(\d+)/(\d+)"#

        // Create a regular expression from the pattern
        let regex = try? NSRegularExpression(pattern: fractionPattern, options: [])

        // Check for matches in the input string
        let matches = regex?.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))

        return matches?.count ?? 0 > 0
    }

    // Helper function to extract quantity from the measure string
    static func extractQuantity(from measure: String) -> String {
        // Check if the measure contains a fraction
        if containsFraction(measure) {
            // Regular expression to match whole numbers, fractions, and mixed numbers
            let regex = try? NSRegularExpression(pattern: "(\\d+\\s*\\d*\\/\\d+|\\d+\\/\\d+|\\d*\\.?\\d+)", options: [])
            let nsString = measure as NSString
            let results = regex?.matches(in: measure, options: [], range: NSRange(location: 0, length: nsString.length))

            // Return the first match if found, otherwise return "1" as default
            if let match = results?.first {
                let quantity = nsString.substring(with: match.range).trimmingCharacters(in: .whitespaces)
                return quantity
            }
        } else {
            // If there's no fraction, we can try to capture whole numbers or decimal numbers
            let regex = try? NSRegularExpression(pattern: "\\d*\\.?\\d+", options: [])
            let nsString = measure as NSString
            let results = regex?.matches(in: measure, options: [], range: NSRange(location: 0, length: nsString.length))

            // Return the first match if found, otherwise return "1" as default
            if let match = results?.first {
                let quantity = nsString.substring(with: match.range).trimmingCharacters(in: .whitespaces)
                return quantity
            }
        }

        return "1" // Default value
    }
}
