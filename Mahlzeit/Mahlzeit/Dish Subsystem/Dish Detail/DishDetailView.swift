//
//  ContentView.swift
//  Mahlzeit
//
//  Created by Marcel Giovanni Munaba on 08.10.24.
//

import SwiftUI
import AlertToast
import PhotosUI
import os

struct DishDetailView: View {
    @Bindable var dishDetailViewModel: DishDetailViewModel
    
    @State var showToast: Bool = false
    
    @State var showPhotoPicker: Bool = false
    
    var logger = Logger()
    
    let customDateFormatter = DateFormatter()
    
    init(_ model: Model, id: Dish.ID) {
        self.dishDetailViewModel = DishDetailViewModel(model, id: id)
        self.showToast = !dishDetailViewModel.dish.completed
        self.customDateFormatter.dateFormat = "dd.MM.yyyy"
    }
    
    // Computed property to show the alert if the dish is completed
    private var showAlert: Bool {
        dishDetailViewModel.getDish(dishDetailViewModel.id).completed
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                dishDetailViewModel
                    .getDish(dishDetailViewModel.id)
                    .image?
                    .getImage()?
                    .resizable()
                    .scaledToFit()
            
                dishDetails
            }
        }
        .background(Color(UIColor.systemBackground))
        .toast(isPresenting: $showToast, duration: 4) { // Toast Alert
            AlertToast(
                displayMode: .banner(.slide),
                type: .complete(Color.green),
                title: "Success"
            )
        }
        .alert(isPresented: .constant(showAlert)) {
            Alert(
                title: Text("Well done!"),
                message: Text("Why don't you take a photo of your dish?"),
                primaryButton: .default(Text("Sure"), action: {
                    showPhotoPicker = true
                }),
                secondaryButton: .cancel(Text("No thanks"))
            )
        }
        .sheet(isPresented: $showPhotoPicker) {
            VStack {
                Text("Upload a picture of your self-made dish")
                    .font(.headline)
                    .padding(.vertical)
                
                imageUpload
            }
        }
        .task(id: dishDetailViewModel.selectedPhoto) {
            if let data = try? await dishDetailViewModel.selectedPhoto?.loadTransferable(type: Data.self) {
                dishDetailViewModel.imageData = data
            }
        }
    }
    
    // Handles image upload after user is finished with a dish
    var imageUpload: some View {
        VStack {
            PhotosPicker(
                selection: $dishDetailViewModel.selectedPhoto,
                matching: .images,
                photoLibrary: .shared()) {
                    Label("Add an Image", systemImage: "photo")
            }
            if let imageData = dishDetailViewModel.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.size.height / 2)
                    .padding(.vertical)
                
                // Enable Save button only if imageData is not nil
                Button {
                    dishDetailViewModel.saveImage(imageData: imageData)
                    showPhotoPicker = false
                    logger.log("Image saved successfully!")
                } label: {
                    Label("Confirm", systemImage: "checkmark")
                        .foregroundStyle(.green)
                }
                .padding(.vertical)
            }
            
            if dishDetailViewModel.imageData != nil {
                Button(role: .destructive) {
                    withAnimation {
                        dishDetailViewModel.selectedPhoto = nil
                        dishDetailViewModel.imageData = nil
                    }
                } label: {
                    Label("Choose another photo", systemImage: "xmark")
                        .foregroundStyle(.red)
                }
                .padding(.vertical)
            }
        }
    }
    
    var dishDetails: some View {
        Group {
            DishDetailsHead

            // Fetch the dish directly, assuming it will always succeed
            let dish = dishDetailViewModel.getDish(dishDetailViewModel.id)

            // Displays the date for completed dishes
            if let date = dish.date {
                Text("You made this previously on \(customDateFormatter.string(from: date))")
                    .font(.subheadline)
                    .padding(.bottom)
            } else {
                Text("*You have not made this dish yet.*")
                    .font(.subheadline)
                    .padding(.bottom)
            }

            Text("\(dishDetailViewModel.cookingTimeString), \(dish.cuisine.rawValue)").font(.subheadline)

            Section {
                Text(dish.description)
                    .font(.subheadline)
                    .padding(.top)
            }

            ingredientsView

            Section(header: Text("Steps").font(.headline).padding(.top)) {
                ForEach(dish.steps, id: \.self) { step in
                    Text(step)
                }
            }

            Section(header: Text("Recommended Videos").font(.headline).padding(.top)) {
                HStack(alignment: .center) {
                    if !dish.recommendedLink.isEmpty, let url = URL(string: dish.recommendedLink) {
                        Link(dish.recommendedLink, destination: url)
                            .foregroundColor(.blue)
                            .truncationMode(.tail)
                    } else {
                        Text("*No recommended video available*").foregroundColor(.gray)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    // Helper for dishDetails
    var ingredientsView: some View {
        let dish = dishDetailViewModel.getDish(dishDetailViewModel.id)
        return Section(header: Text("Ingredients").font(.headline).padding(.top)) {
            ForEach(dish.ingredients, id: \.id) { ingredient in
                Text("\(ingredient.name), \(ingredient.quantity, specifier: "%.1f") \(ingredient.unit)")
            }
        }
    }
    
    // Helper for dishDetails
    var DishDetailsHead: some View {
        HStack {
            Text(dishDetailViewModel.getDish(dishDetailViewModel.id).dishName)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            Button(action: {
                dishDetailViewModel.toggleCompleted()
                showToast.toggle()
            }) {
                ZStack {
                    if dishDetailViewModel.getDish(dishDetailViewModel.id).completed {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)

                        Circle()
                            .stroke(Color.green)
                            .frame(width: 35, height: 35)
                    } else {
                        Image(systemName: "circle")
                            .foregroundColor(.gray)

                        Circle()
                            .stroke(Color.gray)
                            .frame(width: 35, height: 35)
                    }
                }
            }
        }
    }
}
