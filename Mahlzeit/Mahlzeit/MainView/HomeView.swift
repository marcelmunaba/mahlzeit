//
//  HomeView.swift
//  Mahlzeit
//
//  Created by Marcel Giovanni Munaba on 08.10.24.
//

import SwiftUI

struct HomeView: View {
    @Bindable var model: Model
    
    @State var draggingCard: DishCardView?
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var createDishViewModel: CreateDishViewModel
    
    @State private var showingSheet = false
    
    init(_ model: Model, id: Dish.ID) {
        _createDishViewModel = State(wrappedValue: CreateDishViewModel(model, id: id))
        self.model = model
    }
    
    var body: some View {
        NavigationStack {
            dishList
                .navigationTitle("Cooking Wishlist")
            Spacer()
        }
    }
    
    /// Computes the List of CardViews and displays it along with the draggable functionality
    var dishList: some View {
        ScrollView(.vertical) {
            let columns = Array(repeating: GridItem(spacing: 10), count: 1)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(filteredDishCards) { card in
                    NavigationLink(destination: DishDetailView(model, id: card.id)) {
                        card.frame(height: 100)
                            .background(
                                GeometryReader { geometry in
                                    Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
                                }
                            )
                            .draggable(card) {
                                Color.clear.frame(width: UIScreen.main.bounds.size.width - 20, height: 100)
                                    .opacity(0.0)
                                    .onAppear { draggingCard = card }
                            }
                            .contentShape(Rectangle())
                            .dropDestination(for: DishCardView.self) { _, _ in
                                return false
                            } isTargeted: { status in
                                if let draggingCard, status, draggingCard.id != card.id,
                                   let destinationIndex = filteredDishCards.firstIndex(where: { $0.id == card.id }) {
                                    if let sourceIndex = filteredDishCards.firstIndex(where: { $0.id == draggingCard.id }) {
                                        withAnimation(.bouncy) {
                                            let movedDish = model.dishes.remove(at: sourceIndex)
                                            model.dishes.insert(movedDish, at: destinationIndex)
                                        }
                                    }
                                }
                            }
                    }
                    .buttonStyle(PlainButtonStyle()) // Ensure tap gesture doesn't conflict
                }
            }
            addNewDish
        }
    }
    
    /// Computes the Dish creation sheet
    var addNewDish: some View {
        Button("Create a new dish") {
            showingSheet.toggle()
        }
        .padding(.top)
        .sheet(isPresented: $showingSheet, onDismiss: {
            createDishViewModel.reset()
        }) {
            CreateDishView(createDishViewModel: createDishViewModel)
        }
    }
    
    /// Computed property to get the dish cards
    private var filteredDishCards: [DishCardView] {
        model.dishes.compactMap { dish in
            if !dish.completed, dish.image != nil {
                return DishCardView(
                    id: dish.id,
                    model: model,
                    mode: .notCompleted
                )
            } else if dish.completed {
                return nil
            } else {
                return DishCardView(
                    id: dish.id,
                    model: model,
                    mode: .notCompleted
                )
            }
        }
    }
}

/// Relevant for the dragging functionality
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension HomeView {
    enum Mode: String, Codable {
        case completed
        case notCompleted
    }
}
