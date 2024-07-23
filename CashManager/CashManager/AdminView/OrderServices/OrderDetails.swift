//
//  OrderDetails.swift
//  CashManager
//
//  Created by Franck Minassian on 20/12/2022.
//

import Foundation
import SwiftUI

struct OrderDetails: View {
    
    func getFormatedDate(rowDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.date(from: rowDate) ?? Date()
    }
    
    @Binding var orderToShow : OrderBack
    @State var order = OrderBack()
    @State private var groupedProducts = [String : [ProductBack]]()
    let dict = ["key1": "value1", "key2": "value2"]
    var productList = [ProductBack()]
    @State private var totalPriceWithoutTaxes = 0.0
    @State private var taxes = 0.0
    
    var body: some View {
        VStack {
            HStack {
                Text("Détails").font(.title).bold()
            }.padding([.top], 20).padding([.bottom], 40).foregroundColor(.white)
            Spacer()
            VStack (spacing: 5){
                HStack {
                    Text("Date:").font(.title3).bold()
                    Spacer()
                    HStack {
                        Text(getFormatedDate(rowDate: order.created_at), style: .date).font(.title3)
                        Text(getFormatedDate(rowDate: order.created_at), style: .time).font(.title3)
                    }
                }
                HStack {
                    Text("Caissier:").font(.title3).bold()
                    Spacer()
                    Text(order.user.username).font(.title3)
                }
                HStack {
                    Text("Type de payement:").bold().font(.title3)
                    Spacer()
                    if (order.payement == "card") {
                        Image(systemName: "creditcard.fill").imageScale(.large)
                    }
                    if (order.payement == "money") {
                        Image(systemName: "banknote.fill").imageScale(.large)
                    }
                }
            }.foregroundColor(.white).padding([.horizontal], 20)
            Spacer()
            VStack {
                VStack (alignment: .leading) {
                    Text("Liste des produits").font(.title2).bold().foregroundColor(.white)
                }.padding([.top], 40)
                List {
                    ForEach(0..<groupedProducts.count, id: \.self) { index in
                        let entry = Array(groupedProducts)[index]
                        VStack {
                            OrderResumeItem(product: entry.value, barcode: entry.key)
                        }
                        
                    }.foregroundColor(.white).padding([.bottom], 10).listRowBackground(Color("BlueBackground"))
                }
            }
            Spacer()
            VStack {
                HStack {
                    Text("Sous-total:").font(.title3).bold()
                    Spacer()
                    Text("\(String(format: "%.2f", totalPriceWithoutTaxes))€").font(.title3).bold()
                }
                HStack {
                    Text("TVA:").font(.callout)
                    Spacer()
                    Text("\(String(format: "%.2f", taxes))€")
                }
                HStack {
                    Text("Total:").font(.title3).bold()
                    Spacer()
                    Text("\(String(format: "%.2f", order.total_price))€").font(.title3).bold()
                }
            }.padding([.bottom], 20).padding([.top], 10).padding([.horizontal], 20).foregroundColor(.white)
        }.background(Color("BlueBackground")).task {
            order = orderToShow
            groupedProducts = orderToShow.product.groupByBarcode()
            totalPriceWithoutTaxes = Double(order.total_price / 1.20)
            taxes = Double(totalPriceWithoutTaxes) * 0.2
        }
    }
}
