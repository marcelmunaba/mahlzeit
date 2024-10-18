//
//  ViewModel.swift
//  Mahlzeit
//
//  Created by Marcel Giovanni Munaba on 10.10.24.
//
import SwiftUI
import Foundation
import PhotosUI
import os

@Observable public class CreateDishViewModel {
    /// Relevant for image upload
    var imageData: Data?
    var selectedPhoto: PhotosPickerItem?
    
    var dishName: String = ""
    var description: String = ""
    var time = DateComponents(hour: 0, minute: 0)
    var date: Date?
    var selectedCuisine: Dish.Cuisine = .Indonesian // Default selected cuisine
    var steps: [String] = []
    var newStep: String = ""
    var ingredients: [Ingredient] = []
    var recommendedLink: String = ""
    
    var ingredientName: String = ""
    var ingredientQuantity: String = ""
    var selectedUnit: String = ""
    
    var showingAlert = false
    
    var logger = Logger()
    
    /// Indicates whether the dish was already loaded based on the injected `model` property
    var loaded = false
    
    var id: Dish.ID
    
    private weak var model: Model?
    
    /// - Parameter model: The `Model` that is used to interact with the `Dish`
    /// - Parameter id: The `Dish`'s identifier that should be edited
    init(_ model: Model, id: Dish.ID) {
        self.model = model
        self.id = id
    }
    
    func reset() {
        imageData = nil
        selectedPhoto = nil
        dishName = ""
        description = ""
        time = DateComponents(hour: 0, minute: 0)
        selectedCuisine = .Indonesian
        steps = []
        ingredients = []
        recommendedLink = ""
        newStep = ""
        ingredientName = ""
        ingredientQuantity = ""
        selectedUnit = ""
    }
    
    /// Updates the `CreateDish`'s state like the name based on the `id`
    func updateStates() {
        guard let dish = model?.getDishById(id), !loaded else {
            return
        }
        self.selectedPhoto = nil
        self.imageData = dish.image?.pictureData
        self.dishName = dish.dishName
        self.description = dish.description
        self.time = dish.time
        self.date = dish.date
        self.steps = dish.steps
        self.ingredients = dish.ingredients
        self.recommendedLink = dish.recommendedLink
        self.loaded = true
        self.showingAlert = false
    }
    
    /// Saves a dish
    func saveDish() {
        var picture = Picture(pictureData: nil, imageName: nil)
        
        var dish: Dish
        
        if let imageData = imageData {
            picture = Picture(pictureData: imageData, imageName: "")
        }
        dish = Dish(
                dishName: dishName,
                completed: false,
                image: picture,
                time: time,
                description: description,
                steps: steps,
                cuisine: selectedCuisine,
                ingredients: ingredients,
                recommendedLink: recommendedLink
            )
        
        model?.saveDish(dish)
    }
    
    func fetchRandomMeal() {
        Task {
            await model?.fetchRandomMeal()

            guard let randomDish = model?.randomDish else {
                return
            }

            // Fetch the APIImage for the random dish
            if let imageUrl = randomDish.imageUrl {
                var apiImage = APIImage(url: imageUrl)

                // Use weak self to avoid reference cycles - solved with help of ChatGPT :)
                apiImage.fetchImageData { [weak self] data, _ in
                    // Ensure self is still valid
                    guard let self = self else {
                        return
                    }
                    
                    // Update the properties after fetching the image data
                    DispatchQueue.main.async {
                        self.imageData = data // Save the fetched image data
                        self.dishName = randomDish.dishName
                        self.description = randomDish.description
                        self.time = DateComponents(hour: 0, minute: 0)
                        self.selectedCuisine = randomDish.cuisine
                        self.steps = randomDish.steps
                        self.ingredients = randomDish.ingredients
                        self.recommendedLink = randomDish.youtubeLink ?? ""
                        self.newStep = ""
                        self.loaded = true
                    }
                }
            } else {
                // Handle case when there is no image URL - usually won't happen as the API always give an image URL
                logger.log("No image URL available for the random dish.")
            }
        }
    }
        
    func checkFields() -> Bool {
        return dishName.isEmpty || description.isEmpty
        || steps.isEmpty || ingredients.isEmpty
    }
    
    func addIngredient() {
        if !ingredientName.isEmpty, let quantity = Double(ingredientQuantity) {
            let newIngredient = Ingredient(
                name: ingredientName,
                quantity: quantity,
                unit: selectedUnit
            )
            ingredients.append(newIngredient)
            ingredientName = ""
            ingredientQuantity = ""
            selectedUnit = ""
        } else {
            showingAlert = true
        }
    }
    
    func addStep() {
        if !newStep.isEmpty {
            steps.append(newStep)
            newStep = ""
        }
    }
}
