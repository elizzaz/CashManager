//
//  ScanBarCodeView.swift
//  CashManager
//
//  Created by Serge Serci on 28/11/2022.
//

import SwiftUI

struct ScanBarCodeView: View, GetOneProductBackDelegate {
    func onGetOneProductBackSuccess(product: ProductBack) {
        showAlert = true
        success = product.name
    }
    
    func onGetOneProductBackError() {
        error = "error getOneProduct back"
    }
    
    @State private var isPresentingScanner = false
    @State private var scannedCode: String = "tototo"
    @State private var showingPopover = false
    @State private var error = ""
    @State private var success = "Pas encore scanné"
    @State private var showAlert = false
    var request = APIBack()
    
    var body: some View {
        VStack {
            Button() {
                isPresentingScanner = true
            } label: {
                Label("Scannez le produit", systemImage: "barcode.viewfinder").padding().font(.title)
            }
        .foregroundColor(.white)
        .background(Color("LogoIconLogin")).clipShape(RoundedRectangle(cornerRadius: 5))
        }
            .sheet(isPresented: $isPresentingScanner) {
                CodeScannerView(codeTypes: [.ean13, .qr], scanMode: .continuous, showViewfinder: true, simulatedData: "0076808009644") { response in
                if case let .success(result) = response {
                    print(result)
                    scannedCode = result.string
                    print(scannedCode)
                    request.getProductByBarcode(productBarcode: scannedCode, delegate: self)
                    
                }
            }
        }
    }
}

struct ScanBarCodeView_Previews: PreviewProvider {
    static var previews: some View {
        ScanBarCodeView()
    }
}

