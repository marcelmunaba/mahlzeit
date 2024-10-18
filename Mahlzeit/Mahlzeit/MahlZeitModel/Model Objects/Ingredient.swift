//
//  Ingredient.swift
//  Mahlzeit
//
//  Created by Marcel Giovanni Munaba on 10.10.24.
//

import SwiftUI

public struct Ingredient: Identifiable {
    public var id: UUID
    var name: String
    var quantity: Double
    var unit: String
    
    /// Initialiser
    /// Parameters:
    /// - name: Ingredient's name, e.g. "Chicken"
    /// - quantity: Ingredient's count, e.g. 3
    /// - unit: The measuring unit for quantity, e.g. "kg"
    public init(name: String, quantity: Double, unit: String) {
        self.id = UUID()
        self.name = name
        self.quantity = quantity
        self.unit = unit
    }
}
