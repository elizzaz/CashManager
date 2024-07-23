//
//  UpdateCategory.swift
//  CashManager
//
//  Created by Elisa Morillon on 26/12/2022.
//

import Foundation
import SwiftUI

struct UpdateCategory: View , updateCategoryDelegate {
    func updateCategorySuccess(message: String) {
        dismiss()
    }
    
    func updateCategoryError(code: Int, err: String) {
        print(err)
    }
    
    @Environment(\.dismiss) var dismiss
    @Binding var category:Category
    @State var changeCategory = Category()
    @State var newName = ""
    @State var showAlert = false
    @State var titleAlert = ""
    @State var msgAlert = ""
    var request = APIBack()
    
    func UpdateCategory() {
        if (changeCategory.name == "") {
            showAlert = true
            titleAlert = "Une erreur est survenue"
            msgAlert = "Le champs de saisie ne peut pas être vide"
            return
        }
        else{
            print("change categori.name", changeCategory.name)
            newName = changeCategory.name
            print("New name", newName)
            print("after categori.name", changeCategory.name)
            request.updateCategory(category: category, edit: changeCategory, delegate: self)
        }
    }
    
    
    var body: some View {
        VStack {
            VStack{
                Text("Modifier le nom").font(.title).bold().foregroundColor(.white)
                Section("Informations") {
                    TextField("Nom de la catégorie", text: $changeCategory.name).padding([.bottom, .leading, .trailing], 10).foregroundColor(.black)
                }.foregroundColor(.white).padding(10).font(.title3)
                Button (action: {
                    self.UpdateCategory()
                }) {
                    Text("Confirmer").padding([.trailing, .leading], 30).foregroundColor(Color(.white)).padding([.top, .bottom], 15)
                }.background(Color("BtnValidate")).cornerRadius(10).padding([ .trailing],  10)
            }.textFieldStyle(.roundedBorder).padding([.vertical, .horizontal],22).padding([.bottom], 40)
        }.multilineTextAlignment(.center).background(Color("BlueBackground")).textFieldStyle(.roundedBorder).padding(45)
            .onAppear() {
            }
            .alert(isPresented: self.$showAlert) {
                Alert(
                    title: Text(titleAlert),
                    message: Text(msgAlert)
                )
            }
    }
}

