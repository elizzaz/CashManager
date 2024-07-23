//
//  RecapItem.swift
//  CashManager
//
//  Created by Anthony Luong on 03/12/2022.
//

import SwiftUI

struct RecapItem: View {
    
    let product : ProductBack
    
    var body: some View {
        HStack() {
            Spacer().frame(width: 10)
            VStack(alignment: .leading) {
                Text(product.name)
            }
            Spacer()
            HStack() {
                Text("x1")
                    .font(.caption)
                Text("\(String(format: "%.2f", product.price))€")
                    .fontWeight(.semibold)
            }
            Spacer().frame(width: 10)
        }
    }
}

struct RecapItem_Previews: PreviewProvider {
    static var previews: some View {
        RecapItem(product: ProductBack())
    }
}
