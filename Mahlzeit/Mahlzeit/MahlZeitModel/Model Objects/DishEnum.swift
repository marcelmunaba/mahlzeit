//
//  DishEnum.swift
//  Mahlzeit
//
//  Created by Marcel Giovanni Munaba on 12.10.24.
//

extension Dish {
    enum CodingKeys: String, CodingKey {
        case dishName = "strMeal"
        case description = "strCategory"
        case area = "strArea"
        case instructions = "strInstructions"
        case imageUrl = "strMealThumb"
        case youtubeLink = "strYoutube"
        
        // Hard-coded keys for ingredients and measures - I tried to dynamically do this, but no luck.
        case ingredient1 = "strIngredient1"
        case ingredient2 = "strIngredient2"
        case ingredient3 = "strIngredient3"
        case ingredient4 = "strIngredient4"
        case ingredient5 = "strIngredient5"
        case ingredient6 = "strIngredient6"
        case ingredient7 = "strIngredient7"
        case ingredient8 = "strIngredient8"
        case ingredient9 = "strIngredient9"
        case ingredient10 = "strIngredient10"
        case ingredient11 = "strIngredient11"
        case ingredient12 = "strIngredient12"
        case ingredient13 = "strIngredient13"
        case ingredient14 = "strIngredient14"
        case ingredient15 = "strIngredient15"
        case ingredient16 = "strIngredient16"
        case ingredient17 = "strIngredient17"
        case ingredient18 = "strIngredient18"
        case ingredient19 = "strIngredient19"
        case ingredient20 = "strIngredient20"

        case measure1 = "strMeasure1"
        case measure2 = "strMeasure2"
        case measure3 = "strMeasure3"
        case measure4 = "strMeasure4"
        case measure5 = "strMeasure5"
        case measure6 = "strMeasure6"
        case measure7 = "strMeasure7"
        case measure8 = "strMeasure8"
        case measure9 = "strMeasure9"
        case measure10 = "strMeasure10"
        case measure11 = "strMeasure11"
        case measure12 = "strMeasure12"
        case measure13 = "strMeasure13"
        case measure14 = "strMeasure14"
        case measure15 = "strMeasure15"
        case measure16 = "strMeasure16"
        case measure17 = "strMeasure17"
        case measure18 = "strMeasure18"
        case measure19 = "strMeasure19"
        case measure20 = "strMeasure20"
    }
    
    enum Cuisine: String, CaseIterable, Identifiable, Codable {
        case Italian, French, Japanese, Chinese, Indonesian, American, Mexican, Indian
        case Thai, Greek, Korean, Vietnamese, Lebanese, Turkish, British
        case Canadian, Irish, Polish, Arabic, Moroccan, Malaysian
        case Unknown
        var id: Self { self }
    }
}
