//
//  DishDetailViewModel.swift
//  Mahlzeit
//
//  Created by Marcel Giovanni Munaba on 11.10.24.
//

import SwiftUI
import Foundation
import PhotosUI

@Observable public class DishDetailViewModel {
    var id: Dish.ID
    private var model: Model
    var dish: Dish
    var imageData: Data?
    var selectedPhoto: PhotosPickerItem?
    
    /// - Parameter model: The `Model` that is used to interact with the `Dish'
    /// - Parameter id: The `Dish`'s identifier that should be edited
    init(_ model: Model, id: Dish.ID) {
        self.model = model
        self.id = id
        self.dish = model.getDishById(id)
    }
    
    /// Gets the dish by ID
    public func getDish(_ id: Dish.ID) -> Dish {
        return (model.getDishById(id))
    }
    
    /// Method to get the total cooking time in minutes
    public func totalCookingTimeInMinutes() -> Int {
        let hours = model.getDishById(id).time.hour ?? 0
        let minutes = model.getDishById(id).time.minute ?? 0
        return (hours * 60) + minutes
    }
    
    /// Gets the cooking time as String
    public var cookingTimeString: String {
        let hours = model.getDishById(id).time.hour ?? 0
        let minutes = model.getDishById(id).time.minute ?? 0
        
        if hours > 0 {
            return "\(hours) hour\(hours > 1 ? "s" : "") and \(minutes) minute\(minutes > 1 ? "s" : "")"
        } else {
            return "\(minutes) minute\(minutes > 1 ? "s" : "")"
        }
    }
    
    public func toggleCompleted() {
        model.toggleCompleted(id)
    }
    
    // Saves new image
    public func saveImage(imageData: Data) {
        model.saveImage(id: id, imageData: imageData)
    }
    
    public func isDateEmpty() -> Bool {
        guard let date = model.getDishById(id).date else {
            return true
        }
        return false
    }
}
