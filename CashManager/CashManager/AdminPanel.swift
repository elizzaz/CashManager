//
//  Admin_Product.swift
//  CashManager
//
//  Created by Franck Minassian on 28/11/2022.
//

import Foundation
import SwiftUI

struct AdminPanel: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    @State var defaultSelection = 1
    var body: some View {
        TabView(selection: $defaultSelection) {
            CategoryView()
                .tabItem {
                    Label("Produits", systemImage: "cube.fill")
                }.tag(1).padding(.bottom)
            CashierView()
                .tabItem {
                    Label("Caissiers", systemImage: "person.2.fill")
                }.tag(2).padding(.bottom)
            OrderView()
                .tabItem {
                    Label("Commandes", systemImage: "newspaper.fill")
                }.tag(3).padding(.bottom)
        }
    }
}

struct AdminPanel_Previews: PreviewProvider {
    static var previews: some View {
        AdminPanel()
    }
}
