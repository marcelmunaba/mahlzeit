//
//  CreateDishView.swift
//  Mahlzeit
//
//  Created by Marcel Giovanni Munaba on 10.10.24.
//

import SwiftUI
import PhotosUI

struct CreateDishView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var createDishViewModel: CreateDishViewModel
    
    var body: some View {
        Text("What are you cooking today?")
            .font(.custom("Montserrat-Regular", size: 22))
            .padding(.vertical)
        Form {
            imageUpload
            
            Section(header: Text("Dish Name")) {
                TextField("e.g. Chicken and Waffles", text: $createDishViewModel.dishName)
            }
            
            timeCuisine
            
            Section(header: Text("Description")) {
                TextField("Give it a short description..", text: $createDishViewModel.description)
            }
            
            ingredientsSection
            
            stepsSection
            
            Section(header: Text("Recommended")) {
                TextField("Link to your reference recipe. Could also be blank.",
                          text: $createDishViewModel.recommendedLink)
            }
            
            Button(action: {
                //ViewModel calls a function to call API
                createDishViewModel.fetchRandomMeal()
            }) {
                Text("Don't have anything on your mind? Try this.")
            }
        }
        
        Button(action: {
            createDishViewModel.saveDish()
            
            createDishViewModel.reset()

            dismiss()
        }) {
            Text("Save")
        }
        .disabled(createDishViewModel.checkFields())
        .alert("Empty Ingredient name/Invalid quantity.", isPresented: $createDishViewModel.showingAlert) {
            Button("OK", role: .cancel) { }
        }
        .task(id: createDishViewModel.selectedPhoto) {
            if let data = try? await createDishViewModel.selectedPhoto?.loadTransferable(type: Data.self) {
                createDishViewModel.imageData = data
            }
        }
    }
    
    /// Handles Image Upload
    var imageUpload: some View {
        Section {
            PhotosPicker(selection: $createDishViewModel.selectedPhoto,
                         matching: .images,
                         photoLibrary: .shared()) {
                Label("Add an Image", systemImage: "photo")
            }
            
            if createDishViewModel.imageData != nil,
               let uiImage = UIImage(data: createDishViewModel.imageData ?? Data()) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .padding(.vertical)
            }
            
            if createDishViewModel.imageData != nil {
                Button(role: .destructive) {
                    withAnimation {
                        createDishViewModel.selectedPhoto = nil
                        createDishViewModel.imageData = nil
                    }
                } label: {
                    Label("Remove Image", systemImage: "xmark")
                        .foregroundStyle(.red)
                }
            }
        }
    }
    
    var ingredientsSection: some View {
        Section(header: Text("Ingredients")) {
            ForEach(createDishViewModel.ingredients, id: \.name) { ingredient in
                Text("\(ingredient.name) - \(ingredient.quantity, specifier: "%.1f") \(ingredient.unit)")
            }
            
            HStack {
                TextField("Ingredient Name", text: $createDishViewModel.ingredientName)
                TextField("Quantity", text: $createDishViewModel.ingredientQuantity)
                    .keyboardType(.decimalPad)
                TextField("Unit", text: $createDishViewModel.selectedUnit)
            }
            .padding(.vertical)
            
            Button("Add Ingredient") {
                createDishViewModel.addIngredient()
            }
        }
    }
    
    var stepsSection: some View {
        Section(header: Text("Steps")) {
            let stepsCopy = createDishViewModel.steps // Create a copy of the steps
            
            ForEach(stepsCopy.indices, id: \.self) { index in
                TextField("Step \(index + 1)", text: Binding(
                    get: { stepsCopy[index] },
                    set: { createDishViewModel.steps[index] = $0 }
                )).lineLimit(2)
            }
            
            TextField("Add new step", text: $createDishViewModel.newStep)
                .padding(.vertical)
            
            Button("Add Step") {
                createDishViewModel.addStep()
            }
            .disabled(createDishViewModel.newStep.isEmpty)
        }
    }
    
    var timeCuisine: some View {
        Section(header: Text("Cooking Time & Cuisine")) {
            DatePicker("Cooking Time (Hr:Min)",
                       selection: Binding(
                        get: { Calendar.current.date(from: createDishViewModel.time) ?? Date() },
                        set: { newDate in
                            // Update time DateComponents from selected Date
                            createDishViewModel.time = Calendar.current.dateComponents([.hour, .minute], from: newDate)
                        }),
                       displayedComponents: .hourAndMinute)
            
            Picker("Cuisine", selection: $createDishViewModel.selectedCuisine) {
                ForEach(Dish.Cuisine.allCases, id: \.self) { cui in
                    Text(cui.rawValue.capitalized)
                }
            }
        }
    }
}
