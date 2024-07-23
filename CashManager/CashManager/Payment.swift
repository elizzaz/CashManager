//
//  payment.swift
//  CashManager
//
//  Created by Elisa Morillon on 28/11/2022.
//

import SwiftUI
import Lottie
struct Payment: View, GetOneClientDelegate, UpdateClientDelegate, CreateOrderDelegate {
    
    
    func onCreateOrderDelegateSuccess() {
        print("successfully created order")
    }
    
    func onCreateOrderDelegateError(code: Int) {
        print("create order error2")
        print (code)
        statusCode=code
       
    }
    
    func onUpdateClientDelegateSuccess(client: ClientBack) {
        print("sergioooo client success")
        print(client.first_name)
        print("sergioooo client success")
    }
    
    func onUpdateClientDelegateError() {
        print("error on update user")
    }
    
    func onGetOneClientDelegateSuccess(client: ClientBack) {
        print(client.amount)
        for product in productList {
            print(product.id)
            productsId.append(product.id)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            if (client.amount < totalAmount ) {
                status = "refused"
                request.createOrder(client: client.id, products: self.productsId, total_price: totalAmount, status: status, payment_means: payment_means, delegate: self)
            }
            else {
                status = "passed"
                client.amount -= totalAmount
                request.updateClient(clientId: client.id, amount: client.amount, delegate: self)
                request.createOrder(client: client.id, products: self.productsId, total_price: totalAmount, status: status, payment_means: payment_means, delegate: self)
            }
        }
        
    }

    func onGetOneClientDelegateError() {
        print("ça marche pas bitch")
        request.createOrder(client: "", products: self.productsId, total_price: totalAmount, status: status, payment_means: payment_means, delegate: self)
    }

    var request = APIBack()
    @State private var status:String="waiting"
    var clientId = ""
    var totalAmount = 0.0
    var productList = [ProductBack()]
    var payment_means = ""
    @State private var productsId = [String]()

    @State private var statusCode: Int = 0
    
    @State private var limitPaymentAmount = 250
    


    var body: some View {
            ZStack (alignment: .bottom) {
                if status == "waiting"{
                    Rectangle()
                        .fill(Color.white)
                        .border(.blue, width: 4)
                        .frame(minWidth: 0, maxWidth: 350, maxHeight: 550, alignment: .center)
                    VStack{
                        Text("En attente du paiement")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        LottieView(name: "waiting_payment", loopMode: .loop, lottieFile: "waiting_payment")
                            .frame(width: 400, height: 400)
                    }
                }
                if (status == "refused" && statusCode != 403){
                   
                    Rectangle()
                        .fill(Color.white)
                        .border(.red, width: 4)
                        .frame(minWidth: 0, maxWidth: 350, maxHeight: 550, alignment: .center)
                    VStack{
                        Text("Paiement refusé")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        LottieView(name: "failed_and_fuck", loopMode: .loop, lottieFile: "failed_and_fuck")
                            .frame(width: 350, height: 350)
                    }
                }
                if (status == "refused" && statusCode==403){
                   
                    Rectangle()
                        .fill(Color.white)
                        .border(.red, width: 4)
                        .frame(minWidth: 0, maxWidth: 350, maxHeight: 550, alignment: .center)
                    VStack{
                        Text("Arrete de forcer \nEspece de Pauvre")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        LottieView(name: "failed_and_fuck", loopMode: .loop, lottieFile: "failed_and_fuck")
                            .frame(width: 350, height: 350)
                    }
                }
                if status == "passed"{
                    Rectangle()
                        .fill(Color.white)
                        .border(.green, width: 4)
                        .frame(minWidth: 0, maxWidth: 350, maxHeight: 550, alignment: .center)
                    VStack{
                        Text("Paiement accepté")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                        LottieView(name: "payment_succes", loopMode: .loop, lottieFile: "payment_succes")
                            .frame(width: 450, height: 450)
                    }
                    NavigationLink(destination: OrderResumeView(productList: productList)){
                        Text("Voir le reçu")
                    }.padding(.bottom, 40)
                }
            }
            .frame(width: 330, height: 550, alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .circular))
            .shadow(radius: 10)
        .task {
            print(productList[0].name)
            if (payment_means != "card" && totalAmount <= Double(limitPaymentAmount)) {
                status = "passed"
            } else {
                status = "refused"
            }
            request.getOneClient(clientId: clientId, delegate: self)
            for product in productList {
                print(product.id)
                productsId.append(product.id)
            }
        }
    }
        struct Payment_Previews: PreviewProvider {
            static var previews: some View {
                Payment()
            }
        }
    }

