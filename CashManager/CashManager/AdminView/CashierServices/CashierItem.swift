//
//  CashierItem.swift
//  CashManager
//
//  Created by Franck Minassian on 08/12/2022.
//

import SwiftUI

struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct ClearBackgroundViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(ClearBackgroundView())
    }
}

extension View {
    func clearModalBackground()->some View {
        self.modifier(ClearBackgroundViewModifier())
    }
}

extension String {

   func contains(find: String) -> Bool{
     return self.range(of: find) != nil
   }

   func containsIgnoringCase(find: String) -> Bool{
     return self.range(of: find, options: .caseInsensitive) != nil
   }
 }

struct CashierItem: View, getAllUserDelegate, deleteUserDelegate {
    func deleteUserSuccess(message: String) {
        showingAlertDelete = true
        messageAlertDelete = "L'utilisateur à bien été supprimé"
    }
    func deleteUserError(code: Int, err: String) {
        print(code, err)
    }
    
    func getAllUserError(code: Int, err: String) {
        print(code, err)
    }
    func getAllUserSuccess(users: [UserBack]) {
        cashiers = users
    }
    
    var searchResult: [UserBack] {
        if search.CashierSearch.isEmpty {
            return cashiers
        } else {
            var res = [UserBack]()
            for user in cashiers {
                if (user.username.uppercased().contains(find: search.CashierSearch.uppercased()) == true) {
                    res.append(user)
                }
            }
            return res
        }
    }
    @ObservedObject var search: SearchUser
    @State private var showingAlertDelete = false
    @State private var messageAlertDelete = ""
    @State private var dataAlertDelete = ""
    @State private var showingSheetModify = false
    @State var cashiers = [UserBack]()
    @State private var editCashiers = UserBack()
    var request = APIBack()
    
    var body: some View {
        List {
            ForEach(self.searchResult) { cash in
                HStack (alignment: .center,spacing: 30) {
                    VStack {
                        Image(systemName: cash.role == "user" ? "person.fill" :  "crown.fill").imageScale(.large).foregroundColor(Color(cash.role == "admin" ? "GoldenIcon" :  "BlueBackground"))
                    }
                    VStack (alignment: .leading){
                        Text(cash.username) .font(.title2).fontWeight(.bold)
                        Text("#" +  cash.id).font(.title3)
                    }.foregroundColor(Color("BlueBackground"))
                }.swipeActions(edge: .leading) {
                    Button {
                        print(cash.username)
                        self.editCashiers = cash
                        print(editCashiers.username)
                        self.showingSheetModify = true
                    } label: {
                        VStack {
                            Label("Modifier", systemImage: "square.and.pencil")
                            Text("Modifier")
                        }
                    }
                    .tint(.orange)
                }
            }.onDelete { index in
                var elem = UserBack()
                index.forEach { i in
                    elem = searchResult[i]
                }
                cashiers.remove(atOffsets: index)
                request.deleteUser(id: elem.id, delegate: self)
                dataAlertDelete = elem.username
            }
        }.listStyle(.plain).alert(isPresented: $showingAlertDelete) { // 4
            Alert(
                title: Text(messageAlertDelete),
                message: Text(dataAlertDelete)
            )
        }.task {
            request.getAllUser(delegate: self)
        }.popover(isPresented: $showingSheetModify) {
            if #available(iOS 16.0, *) {
                EditCashier(cashier: $editCashiers).presentationDetents([.medium])
            } else {
                EditCashier(cashier: $editCashiers).frame(minWidth: 500, maxWidth: .infinity, minHeight: 1000,maxHeight: 2001, alignment: .bottom).clearModalBackground()
            }
        }.refreshable {
            request.getAllUser(delegate: self)
        }
    }
}

