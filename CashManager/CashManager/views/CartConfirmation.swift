//
//  CartConfirmation.swift
//  CashManager
//
//  Created by Anthony Luong on 03/12/2022.
//

import SwiftUI

struct CartConfirmation: View {
    
    let productList: [ProductBack]
    let totalPrice: Double
    let totalPriceWithoutTaxes: Double
    let taxes: Double
    
    @State private var showingUserMenu = false;
    @State private var email = ""
    
    var body: some View {
            VStack {
                List {
                    ForEach(productList) { product in
                        RecapItem(product: product)
                    }
                }.listStyle(GroupedListStyle())
                
                VStack {
                    Spacer()
                    if (!productList.isEmpty) {
                        HStack {
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
                        Spacer().frame(height: 10)
                        HStack {
                            Text("Total")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(String(format: "%.2f", totalPrice))€")
                                .fontWeight(.medium)
                        }
                    }
                    Spacer().frame(height: 30)
                    HStack {
                        Text("Email du client pour l'envoi du ticket de caisse")
                        Spacer()
                    }
                    TextField("email@gmail.com", text: $email).textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: .infinity)
                    
                    Spacer().frame(height: 30)
                    
                    Button(action: {}) {
                        HStack(alignment: .center) {
                            Image(systemName: "creditcard")
                                .foregroundColor(.white).imageScale(.large)
                            NavigationLink(destination: WichPayment(totalAmount: Double(totalPrice),productList: productList)) {
                                Text("Passer au paiement")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.green)
                    .cornerRadius(10)
                    Spacer()
                }
                .padding(.horizontal).frame(height: 300)
            }
            .navigationBarTitle("Récapitulatif")
            .navigationBarItems(trailing:
                                    Button(action: {
                showingUserMenu = true
            }) {
                Image(systemName: "person.crop.circle").imageScale(.large)
            }
            .confirmationDialog("Menu user", isPresented: $showingUserMenu, actions: {
                Button("Déconnexion", role: .destructive) {}
                Button("Annuler", role: .cancel) {}
            }, message: {
                Text("Que voulez-vous faire ?")
            })
            )

    }
}

struct CartConfirmation_Previews: PreviewProvider {
    static var previews: some View {
        CartConfirmation(productList: [ProductBack()], totalPrice: 0.0, totalPriceWithoutTaxes: 0.0, taxes: 0.0)
    }
}
