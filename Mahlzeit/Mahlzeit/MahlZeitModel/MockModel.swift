//
//  MockModel.swift
//  Mahlzeit
//
//  Created by Marcel Giovanni Munaba on 10.10.24.
//
import SwiftUI
import Foundation

public class MockModel: Model {
    public init() {
        super.init(dishes: [])
        self.dishes = createMockDishes()
    }
    
    /// Generate mock dish list
    public func createMockDishes() -> [Dish] {
        return [createRendang(), createCarbonara(), createOmelette()]
    }
    
    /// Creates a mock dish (Uses nil as pictureData)
    private func createCarbonara() -> Dish {
        Dish(
            dishName: "Carbonara",
            completed: false,
            image: Picture(pictureData: nil, imageName: "carbonara"),
            time: DateComponents(hour: 0, minute: 20),
            description: "A classic Italian pasta dish made with eggs, cheese, pancetta, and pepper.",
            steps: [
                "Boil Pasta for 10 Minutes. Don't forget to salt your pasta water!"
            ],
            cuisine: Dish.Cuisine.Italian,
            ingredients: [
                Ingredient(name: "Pasta", quantity: 150, unit: "grams"),
                Ingredient(name: "Pancetta or Bacon", quantity: 100, unit: "grams"),
                Ingredient(name: "Eggs", quantity: 2, unit: "pcs"),
                Ingredient(name: "Parmesan cheese", quantity: 50, unit: "grams"),
                Ingredient(name: "Black pepper", quantity: 1, unit: "pinch"),
                Ingredient(name: "Salt", quantity: 1, unit: "pinch")
            ]
        )
    }
    
//    private func createLasagna() -> Dish {
//        Dish(
//            dishName: "Lasagna",
//            completed: false,
//            image: Picture(pictureData: nil, imageName: "lasagna"),
//            time: DateComponents(hour: 1, minute: 30),
//            description: "A classic Italian dish with layers of pasta, meat, and cheese.",
//            steps: [
//                "Preheat oven to 375°F (190°C).",
//                "Cook lasagna noodles according to package instructions.",
//                """
//                In a large skillet, cook and crumble ground beef until no longer pink.
//                Drain excess fat.
//                """,
//                "Add marinara sauce to the skillet and simmer for 10 minutes.",
//                "In a bowl, combine ricotta cheese, egg, and a pinch of salt."
//            ],
//            cuisine: Dish.Cuisine.Italian,
//            ingredients: [
//                Ingredient(name: "Lasagna noodles", quantity: 12, unit: "pc"),
//                Ingredient(name: "Ground beef", quantity: 500, unit: "grams"),
//                Ingredient(name: "Marinara sauce", quantity: 700, unit: "ml"),
//                Ingredient(name: "Ricotta cheese", quantity: 450, unit: "grams"),
//                Ingredient(name: "Egg", quantity: 1, unit: "pc"),
//                Ingredient(name: "Mozzarella cheese", quantity: 400, unit: "grams"),
//                Ingredient(name: "Parmesan cheese", quantity: 100, unit: "grams"),
//                Ingredient(name: "Salt", quantity: 1, unit: "pinch")
//            ]
//        )
//    }
    
    /// Creates a mock dish
    private func createOmelette() -> Dish {
        Dish(
            dishName: "Omelette",
            completed: false,
            image: Picture(pictureData: nil, imageName: "omelette"),
            time: DateComponents(hour: 0, minute: 10),
            description: "A simple and quick French dish made with eggs and your choice of fillings.",
            steps: [
                "1. Crack 2 eggs into a bowl, add a pinch of salt and pepper, and beat well with a fork.",
                "2. Heat a non-stick pan over medium-high heat and add a small knob of butter.",
                "3. Pour the beaten eggs into the pan and let them cook undisturbed for about 30 seconds.",
                "4. Use a spatula to gently stir the eggs, then let them set for another 30 seconds.",
                """
                5. Once the eggs are mostly set, add your choice of fillings
                (e.g., cheese, ham, mushrooms, bell peppers) to one half of the omelette.
                """,
                """
                6. Fold the omelette in half and cook for another 1-2 minutes until the eggs are fully set and
                the cheese is melted.
                """,
                "7. Slide the omelette onto a plate and serve immediately."
            ],
            cuisine: Dish.Cuisine.French,
            ingredients: [
                Ingredient(name: "Eggs", quantity: 2, unit: "pcs"),
                Ingredient(name: "Butter", quantity: 1, unit: "knob"),
                Ingredient(name: "Salt", quantity: 1, unit: "pinch"),
                Ingredient(name: "Black pepper", quantity: 1, unit: "pinch"),
            ]
        )
    }
    
    
    /// Creates a mock dish
    private func createRendang() -> Dish {
        Dish(
            dishName: "Rendang",
            completed: false,
            image: Picture(pictureData: nil, imageName: "rendang"),
            time: DateComponents(hour: 4, minute: 0),
            description: "A flavorful and tender Indonesian beef stew",
            steps: [
                "1. Blend shallots, garlic, ginger, galangal, and lemongrass into a fine paste.",
                "2. Heat oil in a large pot over medium heat, add the spice paste and cook until fragrant.",
                "3. Add the beef and cook until browned on all sides.",
                "4. Pour in the coconut milk and add the kaffir lime leaves, turmeric leaves, and lemongrass.",
                """
                5. Bring to a boil, then reduce the heat and simmer uncovered for about 3-4 hours, stirring
                occasionally, until the meat is tender and the sauce has thickened.
                """,
                "6. Season with salt and sugar to taste.",
                """
                7. Continue to cook until the liquid has evaporated and the oil has separated,
                stirring frequently to prevent burning.
                """,
                "8. Serve hot with steamed rice."
            ],
            cuisine: Dish.Cuisine.Indonesian,
            ingredients: [
                Ingredient(name: "Beef", quantity: 1, unit: "kg"),
                Ingredient(name: "Shallots", quantity: 6, unit: "pcs"),
                Ingredient(name: "Garlic cloves", quantity: 5, unit: "pcs"),
                Ingredient(name: "Ginger", quantity: 50, unit: "grams"),
                Ingredient(name: "Galangal", quantity: 50, unit: "grams"),
                Ingredient(name: "Lemongrass", quantity: 2, unit: "stalks"),
                Ingredient(name: "Coconut milk", quantity: 1, unit: "liter"),
                Ingredient(name: "Kaffir lime leaves", quantity: 5, unit: "pcs"),
                Ingredient(name: "Turmeric leaves", quantity: 2, unit: "pcs"),
                Ingredient(name: "Salt", quantity: 1, unit: "tsp"),
                Ingredient(name: "Sugar", quantity: 1, unit: "tbsp"),
                Ingredient(name: "Vegetable oil", quantity: 3, unit: "tbsp")
            ]
        )
    }
}
