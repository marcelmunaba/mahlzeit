//
//  Model.swift
//  Mahlzeit
//
//  Created by Marcel Giovanni Munaba on 10.10.24.
//
import SwiftUI
import Foundation
import os

@Observable public class Model {
    public var dishes: [Dish]
    
    var randomDish: Dish?
    
    var logger = Logger()
    
    private let randomMealDataSource: RandomMealDataSource
    
    /// Initializes a new `Model` for the Mahlzeit app
    /// - Parameters:
    ///    - dishes: The Dishes of the Mahlzeit App
    ///    Initializes the completed dishes by checking 'completed' boolean values for each entry
    public init(
        dishes: [Dish],
        randomMealDataSource: RandomMealDataSource = RealRandomMealDataSource()
    ) {
        self.dishes = dishes
        self.randomMealDataSource = randomMealDataSource
        Task {
            await fetchRandomMeal()
        }
    }
    
    /// Get a `Dish` for a specific ID
    /// - Parameters:
    ///    - id: The id of the `Dish` you wish to find.
    /// - Returns: The corresponding `Dish` if there exists one with the specified id, otherwise a default unknown dish
    public func getDishById(_ id: Dish.ID) -> Dish {
        return dishes.first(where: { $0.id == id }) ?? Dish(
            id: id,
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
    
    /// Saves a created/edited dish
    /// - Parameters:
    ///     - dish: The 'Dish' you wish to save
    public func saveDish(_ dish:Dish) {
        dishes.append(dish)
    }
    
    /// Toggles the completed attribute of a dish
    /// - Parameters:
    ///  - id: The dish's ID
    public func toggleCompleted(_ id: Dish.ID) {
        if let index = dishes.firstIndex(where: { $0.id == id }) {
            dishes[index].completed.toggle()
            if dishes[index].completed {
                dishes[index].date = Date.now
            }
        }
    }
    
    /// Fetches a random meal from the API and updates the model's randomDish property
    public func fetchRandomMeal() async {
        do {
            let randomDish = try await randomMealDataSource.fetchRandomMeal()
            
            // Update the randomDish on the main thread
            DispatchQueue.main.async {
                self.randomDish = randomDish
            }
        } catch {
            logger.log("Failed to fetch random meal: \(error)")
        }
    }
    
    /// Saves new image
    ///  - Parameters:
    ///  - id: The dish's ID
    ///  - imageData: The image Data for the dish
    func saveImage(id: Dish.ID, imageData: Data) {
        // Find the dish by ID
        if let index = dishes.firstIndex(where: { $0.id == id }) {
            // Create a new Picture with the imageData
            let newPicture = Picture(pictureData: imageData, imageName: nil)
            dishes[index].image = newPicture // Set the image of the dish to the new Picture
        }
    }
}
