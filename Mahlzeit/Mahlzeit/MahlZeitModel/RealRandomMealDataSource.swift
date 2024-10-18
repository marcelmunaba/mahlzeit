//
//  RealRandomMealDataSource.swift
//  Mahlzeit
//
//  Created by Marcel Giovanni Munaba on 12.10.24.
//

import Foundation

/// JSON Response in an array with one element
struct MealResponse: Decodable {
    let meals: [Dish]
}

public struct RealRandomMealDataSource: RandomMealDataSource {
    private let endpointURLString = "https://www.themealdb.com/api/json/v1/1/random.php"
    
    public init() {}
    
    /// Fetches a random meal from the RandomMeal API
    /// Returns: Dish
    public func fetchRandomMeal() async throws -> Dish {
        guard let endpointURL = URL(string: endpointURLString) else {
            return Dish(
                id: UUID(),
                dishName: "Unknown",
                completed: false,
                image: nil,
                time: DateComponents(hour: 0, minute: 0),
                description: "",
                steps: [],
                cuisine: .Unknown,
                ingredients: []
            )
        }
        
        let (data, _) = try await URLSession.shared.data(from: endpointURL)
        
        // Decode the outer wrapper
        let mealResponse = try JSONDecoder().decode(MealResponse.self, from: data)
        
        guard let dish = mealResponse.meals.first else {
            throw CustomError.APIerror
        }
        
        return dish
    }
}
