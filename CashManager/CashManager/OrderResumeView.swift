//
//  OrderView.swift
//  CashManager
//
//  Created by Serge Serci on 15/12/2022.
//

import SwiftUI

struct OrderResumeView: View {
    
    var productList = [ProductBack()]
    var request = APIBack()
    
    @State private var totalPrice = 0.0
    @State private var totalPriceWithoutTaxes = 0.0
    @State private var taxes = 0.0
    @State private var quantity = 0
    @State private var groupedProducts = [String : [ProductBack]]()
    let dict = ["key1": "value1", "key2": "value2"]
    
    init(productList: [ProductBack]) {
        self.productList = productList
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Divider().frame(height: 2).overlay(Color("WhiteBackground")).padding(.horizontal)
            VStack {
                //Divider().frame(height: 2).overlay(Color("WhiteBackground"))
                
                //Start Object List
                List {
                    ForEach(0..<groupedProducts.count, id: \.self) { index in
                        let entry = Array(groupedProducts)[index]
                        OrderResumeItem(product: entry.value, barcode: entry.key)

                    }.padding(.horizontal)
                    .listStyle(GroupedListStyle())
                    .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                }.listStyle(.plain)
                
                
                //End Object List
                VStack {
                    Divider().frame(height: 2).overlay(Color("WhiteBackground"))
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
                    }) {
                        HStack(alignment: .center) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.white)
                                .imageScale(.large)
                            NavigationLink(destination: Cart()) {
                                Text("Retour à la caisse")
                                    .foregroundColor(.white)
                                    .bold()
                            }                            
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .cornerRadius(10)
                    Spacer()
                }
                .padding(.horizontal)
            }.navigationTitle("Ticket de caisse")
            
        }
        .task{
            groupedProducts = productList.groupByBarcode()
            print(groupedProducts)
            for product in productList {
                totalPrice += product.price
                totalPriceWithoutTaxes = totalPrice / 1.20
                taxes = totalPriceWithoutTaxes * 0.20
            }
        }
    }
}

struct OrderResumeView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
    }
}
