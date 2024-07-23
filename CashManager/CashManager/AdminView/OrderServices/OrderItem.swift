//
//  OrderItem.swift
//  CashManager
//
//  Created by Franck Minassian on 19/12/2022.
//

import Foundation
import SwiftUI

struct OrderItems: View, GetAllOrdersDelegate  {
    func onGetAllOrdersSuccess(orders: [OrderBack]) {
        self.orders = orders
    }
    
    func onGetAllOrdersError() {
        print("pas marché")
    }
    
    func getFormatedDate(rowDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.date(from: rowDate) ?? Date()
    }
    
    var searchResult: [OrderBack] {
        print(user.cashier)
        let calendar = Calendar.current
        if (start.date > end.date) {
            end.date = start.date
        }
        let start = calendar.date(bySettingHour: 00, minute: 00, second: 00, of: start.date)!
        let end = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: end.date)!
        
        var res = [OrderBack]()
        for order in orders {
            let date = getFormatedDate(rowDate: order.created_at)
            if (user.cashier == "") {
                if (start <= date && end >= date) {
                    res.append(order)
                }
            } else {
                if (start <= date && end >= date && order.user.username == user.cashier) {
                    res.append(order)
                }
            }
        }
        return res
    }
    
//    Gestion de la recherche
    @ObservedObject var start: DateOrder
    @ObservedObject var end: DateOrder
    @ObservedObject var user: CashierFilter
    
//    Request Api
    var request = APIBack()
    @State var orders = [OrderBack] ()

//    Affichage
    @State var dateLabel = Date()
    @State var date = ""
    @State var stockDate = Date()
    @State var showDate = true
    @State var showDetails = false
    
//    Variables
    @State var orderToShow = OrderBack()
    
    var body: some View {
        List {
            ForEach(orders){ order in
                Button(action: {
                    orderToShow = order
                    showDetails = true
                }, label: {
                    HStack {
                        VStack (alignment: .leading) {
                            HStack {
                                Text(getFormatedDate(rowDate: order.created_at), style: .date).bold().font(.title3)
                                Text(getFormatedDate(rowDate: order.created_at), style: .time).bold().font(.title3)
                            }
                            Text(order.user.username)
                            Text("Montant: \(String(format: "%.2f", order.total_price))€")
                            if (order.status == "passed") {
                                Text("Paiement autorisé").foregroundColor(Color.green)
                            } else {
                                Text("Paiement refusé").foregroundColor(Color.red)
                            }
                        }.task{
                            dateLabel = getFormatedDate(rowDate: order.created_at)
                        }
                        Spacer()
                        VStack {
                            if (order.payement == "card") {
                                Image(systemName: "creditcard.fill").imageScale(.large)
                            }
                            if (order.payement == "money") {
                                Image(systemName: "banknote.fill").imageScale(.large)
                            }
                        }
                    }
                })
            }.listRowBackground(Color("BlueBackground")).foregroundColor(.white)
        }.listStyle(.plain).task {
            request.getAllOrder(delegate: self)
        }.background(Color("BlueBackground")).refreshable {
            request.getAllOrder(delegate: self)
        }.sheet(isPresented: $showDetails) {
            OrderDetails(orderToShow: $orderToShow)
        }
    }
}
