//
//  RandomMealDataSource.swift
//  Mahlzeit
//
//  Created by Marcel Giovanni Munaba on 12.10.24.
//

public protocol RandomMealDataSource {
    func fetchRandomMeal() async throws -> Dish
}
