//
//  WichPayment.swift
//  CashManager
//
//  Created by Elisa Morillon on 29/11/2022.
//

import SwiftUI

struct WichPayment: View {
    let nfcReader = NFCReader()
    @State var showActive = false
    @State var clientId = ""
    var totalAmount = 0.0
    var productList = [ProductBack()]
    
    private func readNFC(){
        nfcReader.addOnError { error in
            // put here the code to handle the error
            print("nope")
            print(error.localizedDescription)
        }
        
        nfcReader.addOnRead { result in
            // put here the code to handle the scanned tag content
            print(result)
            clientId = result
            print("sergiooooo")
            showActive = true
        }
        
        nfcReader.beginScanning()
    }
    var body: some View {
            ZStack (alignment: .center){
                Rectangle()
                    .fill(Color.blue)
                    .border(.blue, width: 4)
                    .frame(minWidth: 0, maxWidth: 350, maxHeight: 550, alignment: .center)
                VStack{
                    Text("Choix du paiement")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    HStack (alignment: .center){
                        VStack{
                            LottieView(name: "money", loopMode: .loop, lottieFile: "money")
                                .frame(width: 150, height: 150)
                            NavigationLink(destination: Payment(clientId: clientId, totalAmount: totalAmount, productList: productList, payment_means: "money")) {
                                Text("Chèque")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }
                        VStack{
                            LottieView(name: "card", loopMode: .loop, lottieFile: "card")
                                .frame(width: 150, height: 150)
                            Button(action: readNFC) {
                                Text("Carte bancaire")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }.background(
                                // activated by state programmatically !!
                                NavigationLink(destination: Payment(clientId: clientId, totalAmount: totalAmount, productList: productList, payment_means: "card"), isActive: $showActive) {
                                    EmptyView()     // << just hide
                                })
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .circular))
            .shadow(radius: 10)
    }
    
    struct WichPayment_Previews: PreviewProvider {
        static var previews: some View {
            WichPayment()
        }
    }
}
