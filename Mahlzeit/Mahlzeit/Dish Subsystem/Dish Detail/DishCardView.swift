//
//  ContentView.swift
//  Mahlzeit
//
//  Created by Marcel Giovanni Munaba on 08.10.24.
//

import SwiftUI
import UniformTypeIdentifiers

// Conform to Codable due to draggable
struct DishCardView: View, Identifiable, Codable {
    var id: Dish.ID
    var mode: HomeView.Mode
    
    weak var model: Model?

    enum CodingKeys: CodingKey {
        case id, mode
    }

    init(id: Dish.ID, model: Model, mode: HomeView.Mode) {
        self.id = id
        self.model = model // Assign the model
        self.mode = mode
    }

    // Custom initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Dish.ID.self, forKey: .id)
        self.mode = try container.decode(HomeView.Mode.self, forKey: .mode)
        self.model = nil // Set to nil on decode, as it cannot be stored
    }

    var body: some View {
        ZStack(alignment: .leading) {
            if let dish = model?.getDishById(id) {
                dish.image?.getImage()?
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.size.width - 20, height: 100)
                    .clipped()
                    .opacity(0.8)
                
                cardShade
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(dish.dishName)
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .truncationMode(.tail)
                            .lineLimit(1)

                        Text(dish.description)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .truncationMode(.tail)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    if mode == .notCompleted {
                        Image(systemName: "chevron.up.chevron.down").foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .frame(width: UIScreen.main.bounds.size.width - 20, height: 100)
            } else {
                dishNotFound
            }
        }
        .cornerRadius(10)
    }
    
    var cardShade: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill( mode == .notCompleted ?
                   Color.secondary.gradient.opacity(0.4) :
                    Color.secondary.gradient.opacity(0.5)
            )
            .frame(width: UIScreen.main.bounds.size.width - 20, height: 100)
    }
}

var dishNotFound: some View {
    Text("Dish not found")
        .font(.title)
        .foregroundColor(.white)
        .padding(.horizontal)
}

// Needed for the draggable cards
extension DishCardView: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: DishCardView.self, contentType: .dishCard)
    }
}

extension UTType {
    static var dishCard = UTType(exportedAs: "com.example.dishcard")
}
