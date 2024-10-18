import SwiftUI

struct HistoryView: View {
    @Bindable var model: Model
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            dishList
                .navigationTitle("Your Past Favorites")
        
            Spacer()
        }
    }
    
    var dishList: some View {
        ScrollView(.vertical) {
            let columns = Array(repeating: GridItem(spacing: 10), count: 1)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(filteredDishCards) { card in
                    NavigationLink(destination: DishDetailView(model, id: card.id)) {
                        card.frame(height: 100)
                            .contentShape(Rectangle())
                    }
                }
            }
        }
    }
    
    // Computed property to get the dish cards
    private var filteredDishCards: [DishCardView] {
        model.dishes.compactMap { dish in
            if dish.completed, dish.image != nil {
                return DishCardView(
                    id: dish.id,
                    model: model,
                    mode: .completed
                )
            } else if !dish.completed {
                return nil
            } else {
                return DishCardView(
                    id: dish.id,
                    model: model,
                    mode: .completed
                )
            }
        }
    }
}
