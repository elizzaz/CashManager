//
//  CartItem.swift
//  CashManager
//
//  Created by Anthony Luong on 28/11/2022.
//

import SwiftUI

struct CartItem: View {
    
    let product: ProductBack
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: product.image_url)) { phase in // 1
                        if let image = phase.image { // 2
                            // if the image is valid
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                        } else if phase.error != nil { // 3
                            // some kind of error appears
                            Text("No image available")
                        } else {
                            //appears as placeholder image
                            Image(systemName: "photo") // 4
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                        }
                    }.frame(width: 50, height: 50, alignment: .center)
            VStack(alignment: .leading) {
                Text(product.name)
                    .fontWeight(.semibold)
                Text(product.brand)
                    .foregroundColor(Color.gray)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(String(format: "%.2f", product.price))€")
                    .fontWeight(.semibold)
            }
        }
    }
}

struct CartItem_Previews: PreviewProvider {
    static var previews: some View {
        CartItem(product: ProductBack())
    }
}
