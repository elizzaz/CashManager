//
//  CategoryView.swift
//  CashManager
//
//  Created by Elisa Morillon on 05/12/2022.
//

import SwiftUI
import Drops


struct ClearBackgroundVie: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct ClearBackgroundVieModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(ClearBackgroundVie())
    }
}

extension View {
    func clearMdalBackground()->some View {
        self.modifier(ClearBackgroundVieModifier())
    }
}


struct CategoryView: View, GetAllCategoryBackDelegate, deleteCategoryDelegate, GetOneProductDelegate {
    func deleteCategorySuccess(message: String) {
        
    }
    
    func deleteCategoryError(code: Int, err: String) {
        print(code, err)
    }
    
    let dropError = Drop(
        title: "Erreur",
        subtitle: "Le produit n'a pas pu été trouvé",
        icon: UIImage(systemName: "exclamationmark.circle.fill"),
        position: .top,
        duration: 2.0,
        accessibility: "Alert: Erreur, Le produit n'a pas pu été trouvé"
    )
    
    func onGetOneProductSuccess(product: ProductOFF) {
        isPresentingScanner.toggle()
        productScanned = product
        //        scannedCode = ""
    }
    
    func onGetOneProductError(code: Int, message: String) {
        if code == 404 {
            Drops.show(dropError)
        }
    }
    
    func onGetAllCategoryBackSuccess(category: [Category]) {
        categories = category
        print(categories)
    }
    var request = APIBack()
    var requestOFF = ApiOpenFoodFacts()
    
    func onGetAllCategoryBackError() {
        
    }
    
    
    
    @Environment (\.dismiss) var dismiss
    @State var categories = [Category]()
    @State private var showingSheetAdd = false
    @State private var showingSheetUpdate = false
    @State private var editCategory = Category()
    @State private var editCategoryId = "undefined"
    @State private var isPresentingScanner = false
    @State private var addProductDetailScanned = false
    @State private var addProductDetail = false
    @State private var scannedCode: String = ""
    @State private var productScanned = ProductOFF()
    
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                //                Spacer().frame(height: 100)
                HStack(spacing: 20) {
                    Button(action: {
                        isPresentingScanner.toggle()
                    }) {
                        HStack() {
                            Image(systemName: "plus.circle.fill")
                            Spacer()
                            Text("Ajouter un produit").multilineTextAlignment(.trailing)
                        }
                    }
                    .padding(15)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(10)
                    .contextMenu {
                        Button {
                            isPresentingScanner.toggle()
                        } label: {
                            Label("Scanner un produit", systemImage: "barcode.viewfinder")
                        }
                        Button {
                            addProductDetail.toggle()
                        } label: {
                            Label("Ajouter manuellement", systemImage: "plus.app")
                        }
                    }
                    
                    Button(action: {showingSheetAdd = true
                        // action pour le second bouton
                    }) {
                        Image(systemName: "plus.rectangle.on.folder.fill")
                        Spacer()
                        Text("Ajouter une catégorie").multilineTextAlignment(.trailing)
                        
                    }
                    .padding(15)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(10)
                }
                .padding()
                .sheet(isPresented: $isPresentingScanner, onDismiss: {
                    if (!scannedCode.isEmpty) {
                        addProductDetailScanned.toggle()
                        scannedCode = ""
                    }
                }) {
                    CodeScannerView(codeTypes: [.ean13, .qr], showViewfinder: true) { response in
                        if case let .success(result) = response {
                            scannedCode = result.string
                            requestOFF.getProductByBarcode(barcode: scannedCode, delegate: self)
                        }
                    }
                }
                .sheet(isPresented: $addProductDetailScanned) {
                    if #available(iOS 16.0, *) {
                        AddProductDetails(product: productScanned, categories: categories).presentationDetents([.large])
                    } else {
                        AddProductDetails(product: productScanned, categories: categories)
                    }
                }
                .sheet(isPresented: $addProductDetail) {
                    if #available(iOS 16.0, *) {
                        AddProductDetails(categories: categories).presentationDetents([.large])
                    } else {
                        AddProductDetails(categories: categories)
                    }
                }
                //End Action
                Spacer().frame(height: 15)
                
                //Start Object List
                
                List {
                    ForEach(categories) { category in
                        HStack (alignment: .center,spacing: 30) {
                            NavigationLink(destination: ProductView(category: category)) {
                                Text(category.name)
                                    .padding(10)
                                    .foregroundColor(.black)
                            }
                        }.swipeActions(edge: .leading) {
                            Button {
                                print("coucou")
                                self.editCategory = category
                                self.editCategoryId = category.id
                                self.showingSheetUpdate = true
                            } label: {
                                VStack {
                                    Label("Modifier", systemImage: "square.and.pencil")
                                    Text("Modifier")
                                }
                            }
                            .tint(.orange)
                        }
                    }.onDelete { index in
                        var elem = Category()
                        index.forEach { i in
                            elem = categories[i]
                        }
                        categories.remove(atOffsets: index)
                        request.deleteCategory(id: elem.id, delegate: self)
                        //                            dataAlertDelete = elem.username
                    }
                    //
                }.listRowSeparatorTint(Color("BlueBackground"))
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .navigationTitle("Catégories")
        .background(Color("BlueBackground"))
        .task{
            request.getAllCategory(delegate: self)
        }
        .popover(isPresented: $showingSheetAdd) {
            AddCategory().frame(minWidth: 500, idealWidth: .infinity, maxWidth: 500, minHeight: 1000, idealHeight: 2001, maxHeight: 1002, alignment: .bottom).clearMdalBackground()
        }
        .popover(isPresented: $showingSheetUpdate) {
            UpdateCategory(category: $editCategory)
                .frame(minWidth: 500, idealWidth: .infinity, maxWidth: 500, minHeight: 1000, idealHeight: 2001, maxHeight: 1002, alignment: .bottom).clearMdalBackground()
        }.refreshable {
            request.getAllCategory(delegate: self)
        }
    }
}


