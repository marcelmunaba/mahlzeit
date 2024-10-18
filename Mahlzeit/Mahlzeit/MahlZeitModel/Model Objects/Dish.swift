import SwiftUI

public struct Dish: Identifiable, Decodable {
    public var id: UUID?
    var dishName: String
    var completed: Bool
    public var image: Picture?
    var time: DateComponents
    var description: String
    var steps: [String]
    var date: Date?
    var cuisine: Cuisine
    var ingredients: [Ingredient]
    var recommendedLink: String
    var apiImage: APIImage?

    /// Properties based on the JSON response
    var area: String?
    var instructions: String?
    var imageUrl: String?
    var youtubeLink: String?
    
    /// Dish's initialiser for non-API fetched images
    init(
        id: UUID? = UUID(),
        dishName: String,
        completed: Bool,
        image: Picture?,
        time: DateComponents,
        description: String,
        steps: [String],
        date: Date? = nil,
        cuisine: Cuisine,
        ingredients: [Ingredient],
        recommendedLink: String = "",
        area: String? = nil,
        instructions: String? = nil,
        imageUrl: String? = nil,
        youtubeLink: String? = nil
    ) {
        self.id = id
        self.dishName = dishName
        self.completed = completed
        self.apiImage = nil // nil for user uploaded images
        self.image = image
        self.description = description
        self.time = time
        self.steps = steps
        self.date = date
        self.cuisine = cuisine
        self.ingredients = ingredients
        self.recommendedLink = recommendedLink
        self.area = area
        self.instructions = instructions
        self.imageUrl = imageUrl
        self.youtubeLink = youtubeLink
    }
    
    /// Initialiser for API-fetched images
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = UUID()
        
        self.dishName = try container.decode(String.self, forKey: .dishName)
        
        self.completed = false

        // Decode imageUrl first
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        
        self.image = Picture(pictureData: apiImage?.imageData, imageName: nil)

        self.time = DateComponents(hour: 0, minute: 0)
        
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""

        let rawInstructions = try container.decodeIfPresent(String.self, forKey: .instructions)
        
        self.steps = rawInstructions?
                .components(separatedBy: CharacterSet(charactersIn: "\n\r"))
                .filter { !$0.isEmpty } ?? []
        
        self.date = nil
        
        self.cuisine = Cuisine(
            rawValue: try container.decodeIfPresent(String.self, forKey: .area) ?? "Unknown"
        ) ?? .Unknown
        
        self.ingredients = try Self.decodeIngredients(from: container)
        
        self.recommendedLink = try container.decodeIfPresent(String.self, forKey: .youtubeLink) ?? ""
        
        self.area = try container.decodeIfPresent(String.self, forKey: .area)
        
        self.instructions = try container.decodeIfPresent(String.self, forKey: .instructions)
        
        self.youtubeLink = try container.decodeIfPresent(String.self, forKey: .youtubeLink)
    }
    
    /// Decoder for API
    private static func decodeIngredients(from container: KeyedDecodingContainer<CodingKeys>) throws -> [Ingredient] {
        var ingredients: [Ingredient] = []
        var index = 1

        while true {
            let ingredientKey = "strIngredient\(index)"
            let measureKey = "strMeasure\(index)"

            guard let ingredientKeyEnum = CodingKeys(stringValue: ingredientKey),
                  let measureKeyEnum = CodingKeys(stringValue: measureKey) else {
                break // Exit the loop if keys are not valid
            }

            // Attempt to decode the ingredient and measure
            let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKeyEnum)
            let measure = try container.decodeIfPresent(String.self, forKey: measureKeyEnum)

            // If both ingredient and measure are nil, break the loop - in the JSONResponse it will be "" at some index
            if ingredient == nil && measure == nil {
                break
            }

            // Only process if we have a valid ingredient
            if let ingredient = ingredient, !ingredient.isEmpty {
                let trimmedMeasure = measure?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                let quantityString = QuantityHelper.extractQuantity(from: trimmedMeasure)
                let quantity = Double(quantityString) ?? 0.0
                
                let unit = trimmedMeasure
                    .replacingOccurrences(of: quantityString, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                
                let newIngredient = Ingredient(name: ingredient, quantity: quantity, unit: unit)
                ingredients.append(newIngredient)
            }

            index += 1 // Move to the next ingredient and measure
        }

        return ingredients
    }
}
