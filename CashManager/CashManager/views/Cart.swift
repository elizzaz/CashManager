//
//  Cart.swift
//  CashManager
//
//  Created by Anthony Luong on 27/11/2022.
//

import SwiftUI
import Drops
import AVFoundation

struct Cart: View, GetOneProductBackDelegate {
    
    func onGetOneProductBackSuccess(product: ProductBack) {
        playSound(status: "success")
        showAlert = true
        success = product.name
        
        products.append(product)
        totalPrice += product.price
        totalPriceWithoutTaxes = Double(totalPrice / 1.20)
        taxes = Double(totalPriceWithoutTaxes) * 0.2
        
        Drops.show(dropSuccess)
    }
    
    func onGetOneProductBackError() {
        playSound(status: "error")
        Drops.show(dropError)
    }
    
    let dropSuccess = Drop(
        title: "Succès",
        subtitle: "Produit ajouté au panier",
        icon: UIImage(systemName: "checkmark.circle.fill"),
        action: .init {
            print("Drop tapped")
            Drops.hideCurrent()
        },
        position: .top,
        duration: 2.0,
        accessibility: "Alert: Succès, Produit ajouté au panier"
    )
    
    let dropError = Drop(
        title: "Erreur",
        subtitle: "Le produit n'a pas pu être ajouté au panier",
        icon: UIImage(systemName: "exclamationmark.circle.fill"),
        action: .init {
            print("Drop tapped")
            Drops.hideCurrent()
        },
        position: .top,
        duration: 2.0,
        accessibility: "Alert: Erreur, Le produit n'a pas pu être ajouté au panier"
    )
    
    @State private var isPresentingScanner = false
    @State private var scannedCode: String = "tototo"
    @State private var showingPopover = false
    @State private var error = ""
    @State private var success = "Pas encore scanné"
    @State private var showAlert = false
    
    @State private var totalPrice = 0.0
    @State private var totalPriceWithoutTaxes = 0.0
    @State private var taxes = 0.0
    @State private var quantity = 0
    
    var request = APIBack()
    @State private var audioPlayer: AVAudioPlayer?
    
    @State private var products = [] as [ProductBack]
    @State private var showingUserMenu = false;
    @State private var  JWT = UserDefaults.standard.string(forKey: "JWT")
    
    func playSound(status: String) {
        // Get the path to the sound file
        let enzoSuccess = "scaduto_success"
        let enzoError = "scaduto_error"
        let bip = "bip"
        if (status == "success") {
            if let path = Bundle.main.path(forResource: bip, ofType: "mp3") {
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                        audioPlayer?.play()
                    } catch {
                        print("ERROR")
                    }
                }
        } else {
            if let path = Bundle.main.path(forResource: bip, ofType: "mp3") {
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                        audioPlayer?.play()
                    } catch {
                        print("ERROR")
                    }
                }
        }
        
      }
    
    var body: some View {
            VStack {
                if (!products.isEmpty) {
                    List {
                        ForEach(products) { product in
                            CartItem(product: product)
                        }.onDelete {indexSet in
                            for index in indexSet{
                                delete(index: index, indexSet: indexSet)
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                } else {
                    Text("Le panier est vide.").foregroundColor(.secondary)
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    HStack() {
                        Text("Sous-Total")
                        Text("hors taxes").fontWeight(.light).font(.caption)
                        Spacer()
                        Text("\(String(format: "%.2f", totalPriceWithoutTaxes))€")
                            .fontWeight(.regular)
                    }
                    HStack {
                        Text("TVA")
                        Spacer()
                        Text("\(String(format: "%.2f", taxes))€")
                            .fontWeight(.regular)
                    }
                    Spacer().frame(height: 20)
                    HStack {
                        Text("Total")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(String(format: "%.2f", totalPrice))€")
                            .fontWeight(.medium)
                    }
                    Spacer().frame(height: 30)
                    Button(action: {
                        isPresentingScanner.toggle()
                    }) {
                        HStack(alignment: .center) {
                            Image(systemName: "barcode.viewfinder")
                                .foregroundColor(.white)
                                .imageScale(.large)
                            Text("Scanner le produit")
                                .foregroundColor(.white)
                                .bold()
                            
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .cornerRadius(10)
                    
                    if (!products.isEmpty) {
                        NavigationLink(destination: CartConfirmation(productList: products, totalPrice: totalPrice, totalPriceWithoutTaxes: totalPriceWithoutTaxes, taxes: taxes)) {
                            Image(systemName: "cart")
                                .foregroundColor(.white).imageScale(.large)
                            Text("Valider le panier")
                                .foregroundColor(.white)
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.green)
                        .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding(.horizontal).frame(height: products.isEmpty ? 240 : 300)
            }
            .navigationBarTitle("Panier")
            .navigationBarItems(trailing:
                                    Button(action: {
                showingUserMenu = true
            }) {
                Image(systemName: "person.crop.circle").imageScale(.large)
            }.confirmationDialog("Menu user", isPresented: $showingUserMenu, actions: {
                Button("Déconnexion", role: .destructive) {}
                Button("Annuler", role: .cancel) {}
            }, message: {
                Text("Que voulez-vous faire ?")
            })
            )
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isPresentingScanner) {
            CodeScannerView(codeTypes: [.ean13, .qr], scanMode: .continuous, showViewfinder: true) { response in
                if case let .success(result) = response {
                    scannedCode = result.string
                    request.getProductByBarcode(productBarcode: scannedCode, delegate: self)
                }
            }
        }
    }
    
    func delete(index: Int, indexSet: IndexSet) {
        totalPrice -= products[index].price
        totalPriceWithoutTaxes = totalPrice / 1.2
        taxes = totalPriceWithoutTaxes * 0.2
        products.remove(atOffsets: indexSet)
    }
}

struct Cart_Previews: PreviewProvider {
    static var previews: some View {
        Cart()
    }
}
