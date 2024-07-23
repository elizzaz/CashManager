//
//  OrderView.swift
//  CashManager
//
//  Created by Franck Minassian on 28/11/2022.
//

import SwiftUI

class DateOrder: ObservableObject {
    @Published var date = Date()
}

class CashierFilter: ObservableObject {
    @Published var cashier = ""
}

struct OrderView: View, getAllUserDelegate {
    func getAllUserSuccess(users: [UserBack]) {
        self.users = users
    }
    func getAllUserError(code: Int, err: String) {
        print(err)
    }
    
    var request = APIBack()
    @State var users = [UserBack] ()
    @ObservedObject var start = DateOrder()
    @ObservedObject var end = DateOrder()
    @ObservedObject var user = CashierFilter()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UITextField.appearance(whenContainedInInstancesOf:[UISearchBar.self]).backgroundColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        UITableView.appearance().backgroundColor = UIColor.red
    }
    var body: some View {
        VStack {
            VStack {
                
                HStack {
                    VStack {
                        DatePicker ("Début", selection: $start.date,in: ...Date(), displayedComponents: [.date]).foregroundColor(Color("BlueBackground")).accentColor(Color("BlueBackground"))
                    }.padding(10).background(Color.white).cornerRadius(10)
                    Spacer()
                    VStack {
                        DatePicker ("Fin", selection: $end.date,in: ...Date(), displayedComponents: [.date]).foregroundColor(Color("BlueBackground")).accentColor(Color("BlueBackground"))
                    }.padding(10).background(Color.white).cornerRadius(10)
                }.padding([.leading, .trailing], 10)
                Spacer()
                HStack {
                    Spacer()
                    HStack {
                        Picker("Sélectionner un caissier", selection: $user.cashier) {
                            Text("Selectionner un caissier").tag("")
                            ForEach (users) {user in
                                Text(user.username).tag(user.username)
                            }
                        }
                    }.frame(maxWidth: .infinity).padding(10).background(.white).cornerRadius(10)
                    Spacer()
                }
                
                Spacer().frame(height: 10)
                VStack {
                    OrderItems(start: start, end: end, user: user)
                }
                Spacer()
            }.navigationTitle("Commandes").background(Color("BlueBackground")).task {
                request.getAllUser(delegate: self)
            }
        }
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
    }
}
