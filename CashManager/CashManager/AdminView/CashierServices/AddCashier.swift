//
//  AddCashier.swift
//  CashManager
//
//  Created by Franck Minassian on 09/12/2022.
//

import Foundation
import SwiftUI

struct AddCashier: View, createUserDelegate {
    func createUserSuccess(message: String) {
        dismiss()
    }
    
    func createUserError(code: Int, err: String) {
        showAlert = true
        titleAlert = "Une erreur est survenue"
        msgAlert = err
    }
    
    func addNewCashier() {
        if (newCashier.username == "") {
            showAlert = true
            titleAlert = "Une erreur est survenue"
            msgAlert = "Tous les champs doivent être remplis"
            return
        }
        if (newCashier.password != confirmPassword) {
            showAlert = true
            titleAlert = "Une erreur est survenue"
            msgAlert = "Les mots de passe doivents être similaire"
            return
        }
        newCashier.role = role
        request.createUser(user: newCashier, delegate: self)
    }
    
    @Environment(\.dismiss) var dismiss
    @State var newCashier = UserBack()
    @State var role = "user"
    @State var confirmPassword = ""
    @State var showAlert = false
    @State var titleAlert = ""
    @State var msgAlert = ""
    var request = APIBack()
    var body: some View {
        VStack {
            VStack{
                Text("Ajouter un caissier").font(.title).bold().foregroundColor(.white).padding([.top], 30)
                Section("Informations") {
                    TextField("Nom d'utilisateur", text:$newCashier.username).padding([.bottom, .leading, .trailing], 10).foregroundColor(.black)
                    SecureField("Mot de passe", text:$newCashier.password).padding([.bottom, .leading, .trailing], 10).foregroundColor(.black)
                    SecureField("Confirmez le mot de passe", text:$confirmPassword).padding([.bottom, .leading, .trailing], 10).foregroundColor(.black)
                }.foregroundColor(.white).padding([.top], 10).font(.title3)
                HStack {
                    Label("Rôle", image: "")
                    Picker("Role", selection: $role) {
                        Text("Utilisateur").tag("user")
                        Text("Administrateur").tag("admin")
                    }.background(.white).tint(.black)
                }.foregroundColor(.white).padding([.bottom], 20).font(.title3)
                Button (action: {
                    self.addNewCashier()
                }) {
                    Text("Ajouter").padding([.trailing, .leading], 30).foregroundColor(Color(.white)).padding([.top, .bottom], 15)
                }.background(Color("BtnValidate")).cornerRadius(10)
            }.textFieldStyle(.roundedBorder)
        }.multilineTextAlignment(.center).textFieldStyle(.roundedBorder).background(Color("BlueBackground"))
            .alert(isPresented: self.$showAlert) {
                Alert(
                    title: Text(titleAlert),
                    message: Text(msgAlert)
                )
            }.task {
                newCashier.role = "user"
            }
    }
}
