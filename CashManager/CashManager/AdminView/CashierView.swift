//
//  CashierView.swift
//  CashManager
//
//  Created by Franck Minassian on 28/11/2022.
//

import SwiftUI

class SearchUser: ObservableObject {
    @Published var CashierSearch = ""
}

struct CashierView: View {
    @ObservedObject var search = SearchUser()
    @State private var showingSheetAdd = false
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UITextField.appearance(whenContainedInInstancesOf:[UISearchBar.self]).backgroundColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        UITableView.appearance().backgroundColor = UIColor.red
    }
    
    var body: some View {
        VStack {
            VStack (alignment: .trailing) {
                VStack (spacing: 5) {
                    VStack {
                        HStack {
                        }.searchable(text: $search.CashierSearch, prompt: Text("Chercher un caissier"))
                    }
                    VStack (alignment: .leading, spacing: 0  ){
                        Button (action: {
                            showingSheetAdd = true
                        }) {
                            Image(systemName: "plus.circle.fill").padding(10).foregroundColor(Color(.white))
                            Text("Nouveau Caissier").padding(15).foregroundColor(Color(.white))
                        }.background(Color("BtnValidate")).cornerRadius(10).padding([ .trailing],  20)
                    }
                }
                Spacer().frame(height: 15)
                VStack {
                    CashierItem(search: search)
                }
            }.navigationTitle("Caissier").background(Color("BlueBackground").ignoresSafeArea())
                .sheet(isPresented: $showingSheetAdd) {
                    if #available(iOS 16.0, *) {
                        AddCashier().presentationDetents([.medium])
                    } else {
                        AddCashier().frame(minWidth: 500, maxWidth: .infinity, minHeight: 1000, maxHeight: 2002, alignment: .bottom).clearModalBackground()                        
                    }
                }
            
        }
    }
}

struct CashierView_Previews: PreviewProvider {
    static var previews: some View {
        CashierView()
    }
}
