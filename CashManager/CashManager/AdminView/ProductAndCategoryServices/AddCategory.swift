//
//  AddCategory.swift
//  CashManager
//
//  Created by Elisa Morillon on 13/12/2022.
//

import SwiftUI

struct AddCategory: View , createCategoryDelegate {
    func createCategorySuccess(message: String) {
        dismiss()
    }
    
    func createCategoryError(code: Int, err: String) {
        showAlert = true
        titleAlert = "Une erreur est survenue"
        msgAlert = err
    }


    func addNewCategory() {
        if (newCategory.name == "") {
            showAlert = true
            titleAlert = "Une erreur est survenue"
            msgAlert = "Le champs de saisie ne peut pas être vide"
            return
        }
        request.createCategory(category: newCategory, delegate: self)
    }

    @Environment(\.dismiss) var dismiss
    @State var newCategory = Category()
    @State var showAlert = false
    @State var titleAlert = ""
    @State var msgAlert = ""
    var request = APIBack()
    
    var body: some View {
        VStack {
            VStack{
                Text("Ajouter une catégorie").font(.title).bold().foregroundColor(.white)
                Section("Informations") {
                    TextField("Nom de la catégorie", text:$newCategory.name).padding([.bottom, .leading, .trailing], 10).foregroundColor(.black)
                }.foregroundColor(.white).padding(10).font(.title3)
                Button (action: {
                    self.addNewCategory()
                }) {
                    Text("Ajouter").padding([.trailing, .leading], 30).foregroundColor(Color(.white)).padding([.top, .bottom], 15)
                }.background(Color("BtnValidate")).cornerRadius(10).padding([ .trailing],  10)
            }.textFieldStyle(.roundedBorder).padding([.vertical, .horizontal],22).padding([.bottom], 40)
        }.multilineTextAlignment(.center).background(Color("BlueBackground")).textFieldStyle(.roundedBorder).padding(45)
            .alert(isPresented: self.$showAlert) {
                Alert(
                    title: Text(titleAlert),
                    message: Text(msgAlert)
                )
            }.task {
                newCategory.name = "Nom de la catégorie"
            }
    }
    
    struct AddCategory_Previews: PreviewProvider {
        static var previews: some View {
            AddCategory()
        }
    }
}
