//
//  ProductView.swift
//  CashManager
//
//  Created by Franck Minassian on 28/11/2022.
//

import SwiftUI
import Drops

struct ProductView: View, GetProductByCategoryBackDelegate, deleteProductBackDelegate {
    
    func onDeleteProductBackSuccess(message: String) {
        Drops.show(dropOnSuccess(subtitle: "Produit supprimé avec succès"))
    }
    
    func onDeleteProductBackError(code: Int, err: String) {
        Drops.show(dropOnError(subtitle: "Impossble de supprimer le produit"))
    }
    
    func onGetProductByCategoryBackSuccess(product: [ProductBack]) {
        self.products = product
        
        if (products.isEmpty) {
            emptyProducts = true
        }
    }
    
    func onGetProductByCategoryBackError() {
        Drops.show(dropOnError(subtitle: "Erreur lors du chargement des produits de cette catégorie."))
    }
    
    
    @State var products = [ProductBack]()
    @State var emptyProducts: Bool = false
    var request = APIBack()
    var category: Category
    @State var editProduct = ProductBack()
    @State private var selectedProduct = ProductBack()
    @State private var showingProductActions: Bool = false
    @State private var showingEditProductModal: Bool = false
    
    @State private var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    
    var body: some View {
        VStack {
            if (!emptyProducts) {
                ScrollView {
                    LazyVGrid(columns: gridItemLayout) {
                        ForEach(products) { product in
                            VStack {
                                Spacer()
                                AsyncImage(url: URL(string: product.image_url)) { phase in
                                    if let image = phase.image { // 2
                                        // if the image is valid
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(10)
                                    } else if phase.error != nil { // 3
                                        // some kind of error appears
                                        Text("No image available")
                                    } else {
                                        //appears as placeholder image
                                        Image(systemName: "photo") // 4
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(Color("BlueBackground"))
                                            .cornerRadius(10)
                                    }
                                }.frame(width: 100, height: 100, alignment: .center)
                                
                                Text(product.name).foregroundColor(Color("BlueBackground"))
                                    .bold()
                                    .multilineTextAlignment(.center)
                                Spacer()
                                Text("\(String(format:"%.2f", product.price))€")
                                    .foregroundColor(Color("BlueBackground"))
                                Spacer()
                            }
                            .onTapGesture(perform: {
                                selectedProduct = product
                                showingProductActions.toggle()
                            })
                            .frame(maxWidth: .infinity, minHeight: 150)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.bottom, 10)
                            .confirmationDialog("Menu produit", isPresented: $showingProductActions, actions: {
                                Button("Editer le produit") {
                                    showingEditProductModal.toggle()
                                }
                                Button("Supprimer le produit", role: .destructive) {
                                    request.deleteProduct(product: selectedProduct, delegate: self)
                                }
                            }, message: {
                                Text("Que voulez-vous faire ?")
                            })
                            .sheet(isPresented: $showingEditProductModal) {
                                EditProduct(product: selectedProduct)
                            }
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                }
            } else {
                VStack {
                    Text("Aucun produit n'est présent dans cette catégorie.").foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.top, 20)
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .navigationTitle(category.name)
        .background(Color("BlueBackground"))
        .task{
            request.getProductByCatgeory(category: category, delegate: self)
        }
    }
    
}
