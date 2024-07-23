//
//  EditCashier.swift
//  CashManager
//
//  Created by Franck Minassian on 08/12/2022.
//

import Foundation
import SwiftUI

struct EditCashier: View, updateUserDelegate{
    func updateUserSuccess(message: String) {
        dismiss()
    }
    
    func updateUserError(code: Int, err: String) {
        print(err)
    }
    
    @Binding var cashier: UserBack
    @State var editCashier = UserBack()
    @State var newPassword = ""
    @State var confirmPassword = ""
    @State var role = ""
    @State var showAlert = false
    @State var msgAlert = ""
    @State var titleAlert = ""
    @Environment(\.dismiss) var dismiss
    var request = APIBack()
    
    func editCashierFunc() {
        if (self.newPassword != "" && self.confirmPassword != "") {
            if (self.newPassword != self.confirmPassword) {
                self.showAlert = true
                self.titleAlert = "Une erreur est survenue"
                self.msgAlert = "Les mot de passe ne sont pas similaire"
                return
            }
            if (self.newPassword == self.editCashier.password) {
                self.showAlert = true
                self.titleAlert = "Une erreur est survenue"
                self.msgAlert = "Le mot de passe doit être différent du précédent"
                return
            }
            editCashier.password = newPassword
        }
        editCashier.role = role
        request.updateUser(user: cashier, edit: editCashier, delegate: self)
    }
    
    var body: some View {
        VStack {
            Text("Modifier les Informations").font(.title).bold().foregroundColor(.white).padding([.top], 10)
            Section("Informations") {
                TextField("Identifiant", text:$editCashier.id).padding([.bottom, .leading, .trailing], 10).disabled(true).foregroundColor(.gray)
                TextField("Nom d'utilisateur", text:$editCashier.username).padding([.bottom, .leading, .trailing], 10).foregroundColor(.black)
                SecureField("Nouveau mot de passe", text:$newPassword).padding([.bottom, .leading, .trailing], 10).foregroundColor(.black)
                SecureField("Confirmez le mot de passe", text:$confirmPassword).padding([.bottom, .leading, .trailing], 10).foregroundColor(.black)
            }.foregroundColor(.white).padding([.top], 10).font(.title3)
            HStack {
                Label("Rôle: ", image: "")
                Picker("Role", selection: $role) {
                    Text("Utilisateur").tag("user")
                    Text("Administrateur").tag("admin")
                }.background(.white).tint(.black)
            }.foregroundColor(.white).padding([.bottom], 20).font(.title3)
            Button (action: {
                self.editCashierFunc()
            }) {
                Text("Modifier").padding([.trailing, .leading], 30).foregroundColor(Color(.white)).padding([.top, .bottom], 15)
            }.background(Color("GoldenIcon")).cornerRadius(10)
        }.multilineTextAlignment(.center).padding([.horizontal], 20).textFieldStyle(.roundedBorder)
            .onAppear() {
                self.editCashier = self.cashier
                self.role = self.cashier.role
            }.alert(isPresented: self.$showAlert) {
                Alert(
                    title: Text(titleAlert),
                    message: Text(msgAlert)
                )
            }.background(Color("BlueBackground")).ignoresSafeArea(.all)
    }
}
