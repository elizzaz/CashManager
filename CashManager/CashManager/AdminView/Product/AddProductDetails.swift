//
//  AddProductDetails.swift
//  CashManager
//
//  Created by Anthony Luong on 19/12/2022.
//

import SwiftUI
import Drops

struct AddProductDetails: View, createProductBackDelegate {
    
    func onCreateProductBackSuccess(message: String) {
        Drops.show(dropOnSuccess(subtitle: "Produit ajouté avec succès"))
        dismiss()
    }
    
    func onCreateProductBackError(code: Int, err: String) {
        showAlert = true
        titleAlert = "Une erreur est survenue"
        if (code == 422) {
            msgAlert = "Ce produit existe déjà dans la base de données."
        } else {
            msgAlert = String(code)
        }
    }
    
    var product: ProductOFF?
    var categories: [Category]
    
    @State private var productPrice: Double = 0.0
    @State private var productURL: String = ""
    @State private var productBrand: String = ""
    @State private var showAlert: Bool = false
    @State private var titleAlert: String = ""
    @State private var msgAlert: String = ""
    @State private var productCategory: String = ""
    
    @State private var newProduct = ProductBack()
    @State private var request = APIBack()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Ajouter un produit").font(.title).bold().foregroundColor(.white)
            Spacer().frame(height: 20)
            AsyncImage(url: URL(string: product?.image_url ?? "")) { phase in
                        if let image = phase.image { // 2
                            // if the image is valid
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else if phase.error != nil { // 3
                            // some kind of error appears
                            Text("No image available")
                        } else {
                            //appears as placeholder image
                            Image(systemName: "photo") // 4
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                        }
                    }.frame(width: 200, height: 200, alignment: .center)
            Spacer().frame(height: 20)
            Section {
                TextField("Intitulé", text: $newProduct.name)
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                    .autocorrectionDisabled()
                TextField("Marque", text: $productBrand)
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                    .autocorrectionDisabled()
                TextField("Code barre", text: $newProduct.barcode)
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                    .keyboardType(.numberPad)
                TextField("Prix", value: $productPrice, format: .currency(code: Locale.current.currencyCode ?? "€"))
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                    .keyboardType(.decimalPad)
            } header: {
                HStack {
                    Text("Informations liées au produit")
                        .foregroundColor(.white)
                        .font(.title3)
                    Spacer()
                }
            }
            
            HStack {
                Text("Catégorie du produit").foregroundColor(.secondary)
                Spacer()
                Picker(selection: $productCategory) {
                    ForEach(categories) { category in
                        Text(category.name)
                            .tag(category.id)
                            .foregroundColor(.primary)
                    }
                } label: {
                    Text("Catégories").foregroundColor(Color.primary)
                }
            }.frame(maxWidth: .infinity)
                .padding().background(.white).cornerRadius(10)
            Spacer()
            
            Button(action: {
                addNewProduct()
            }) {
                HStack(alignment: .center) {
                    Image(systemName: "plus")
                        .foregroundColor(.white).imageScale(.large)
                    Text("Ajouter le produit")
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.green)
            .cornerRadius(10)
            
        }
        .alert(isPresented: self.$showAlert) {
            Alert(
                title: Text(titleAlert),
                message: Text(msgAlert)
            )
        }
        .task {
            newProduct.name = product?.name ?? ""
            productBrand = product?.brand ?? ""
            newProduct.barcode = product?.barcode ?? ""
            newProduct.image_url = product?.image_url ?? ""
            if (!categories.isEmpty) {
                productCategory = categories[0].id
            }
        }
        .padding()
        .background(Color("BlueBackground"))
    }
    
    func addNewProduct() {
        if (newProduct.barcode.isEmpty || newProduct.name.isEmpty || String(productPrice).isEmpty || productCategory.isEmpty) {
            showAlert = true
            titleAlert = "Une erreur est survenue"
            msgAlert = "Tous les champs doivent être remplis afin de pouvoir créer le produit."
            return
        }
        newProduct.image_url = product?.image_url ?? ""
        newProduct.brand = productBrand
        newProduct.price = Double(productPrice)
        newProduct.category.id = productCategory
        request.createProduct(product: newProduct, delegate: self)
    }
}
