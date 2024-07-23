//
//  OrderResumeItem.swift
//  CashManager
//
//  Created by Serge Serci on 17/12/2022.
//

import SwiftUI

struct OrderResumeItem: View {
    let product: [ProductBack]
    let barcode: String    
    var body: some View {
        HStack {
            
            VStack(alignment: .leading) {
                Text(product[0].name)
                    .fontWeight(.semibold)
            }
            Spacer()
            Spacer()
            Spacer()
            Text("x\(product.count)")
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(String(format: "%.2f", Double(product.count) * product[0].price))€")
                    .fontWeight(.semibold)
            }
        }
    }
}

struct OrderResumeItem_Previews: PreviewProvider {
    static var previews: some View {
        OrderResumeItem(product: [ProductBack()], barcode: "")
    }
}
