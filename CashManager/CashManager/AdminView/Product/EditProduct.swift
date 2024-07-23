//
//  EditProduct.swift
//  CashManager
//
//  Created by Anthony Luong on 27/12/2022.
//

import SwiftUI
import Drops

struct EditProduct: View, GetAllCategoryBackDelegate, updateProductBackDelegate {
    
    func onUpdateProductBackSuccess(message: String) {
        Drops.show(dropOnSuccess(subtitle: "Produit modifié avec succès"))
        dismiss()
    }
    
    func onUpdateProductBackError(code: Int, err: String) {
        Drops.show(dropOnError(subtitle: "Erreur lors de la modification du produit"))
    }
    
    func onGetAllCategoryBackSuccess(category: [Category]) {
        categories = category
    }
    
    func onGetAllCategoryBackError() {
        print("erreur lors du chargement des catégories")
    }
    
    
    let product: ProductBack
    
    var request = APIBack()
    
    @State private var isInitialized: Bool = false
    @State private var productName: String = ""
    @State private var productBrand: String = ""
    @State private var productBarcode: String = ""
    @State private var productPrice: Double = 0.0
    @State private var productCategory: String = ""
    
    @State private var showAlert: Bool = false
    @State private var titleAlert: String = ""
    @State private var msgAlert: String = ""
    
    @State private var newProduct = ProductBack()
    @State private var categories = [Category]()
    
    @Environment(\.dismiss) var dismiss
    
    init(product: ProductBack) {
        let categoryId = product.category.id
        self.product = product
        _productName = State(initialValue: product.name)
        _productBrand = State(initialValue: product.brand)
        _productPrice = State(initialValue: Double(product.price))
        _productBarcode = State(initialValue: product.barcode)
        _productCategory = State(initialValue: categoryId)
    }
    
    var body: some View {
        VStack {
            Text("Editer un produit").font(.title).bold().foregroundColor(.white)
            Spacer().frame(height: 20)
            AsyncImage(url: URL(string: product.image_url)) { phase in // 1
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
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                    }.frame(width: 200, height: 200, alignment: .center)
            Spacer().frame(height: 20)
            Section {
                TextField("Intitulé", text: $productName)
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                    .autocorrectionDisabled()
                TextField("Marque", text: $productBrand)
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                    .autocorrectionDisabled()
                TextField("Code barre", text: $productBarcode)
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
                Group {
                    Picker(selection: $productCategory) {
                        if (!categories.isEmpty) {
                            ForEach(categories) { category in
                                Text(category.name)
                                    .tag(category.id)
                                    .foregroundColor(.primary)
                            }
                        } else {
                            Text("-")
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                    } label: {
                        Text("Catégories").foregroundColor(Color.primary)
                    }
                }
            }.frame(maxWidth: .infinity)
                .padding().background(.white).cornerRadius(10)
            Spacer()
            
            Button(action: {
                editProduct()
            }) {
                HStack(alignment: .center) {
                    Image(systemName: "pencil")
                        .foregroundColor(.white).imageScale(.large)
                    Text("Éditer le produit")
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.orange)
            .cornerRadius(10)
            
        }
        .padding()
        .background(Color("BlueBackground"))
        .task({
            request.getAllCategory(delegate: self)
        })
        
    }
    func editProduct() {
        if (productBarcode.isEmpty || productName.isEmpty || String(productPrice).isEmpty || productCategory.isEmpty) {
            showAlert = true
            titleAlert = "Une erreur est survenue"
            msgAlert = "Tous les champs doivent être remplis afin de pouvoir éditer le produit."
            return
        }
        newProduct.id = product.id
        newProduct.image_url = product.image_url
        newProduct.name = productName
        newProduct.brand = productBrand
        newProduct.barcode = productBarcode
        newProduct.price = Double(productPrice)
        newProduct.category.id = productCategory
        
        request.updateProduct(product: newProduct, delegate: self)
    }
}

struct EditProduct_Previews: PreviewProvider {
    static var previews: some View {
        EditProduct(product: ProductBack())
    }
}
