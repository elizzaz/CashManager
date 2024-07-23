//
//  Login.swift
//  CashManager
//
//  Created by Serge Serci on 22/11/2022.
//

import SwiftUI
import Drops


struct Login: View , PostAuthenticateBackDelegate{
    
    func onPostAuthenticateBackSuccess(jwt: String) {
        
        saveJWT=jwt
        UserDefaults.standard.set(self.saveJWT, forKey: "JWT")
        action = true
        isPresentingScanner=false
        
    }
    
    func onPostAuthenticateBackError() {
        
        print("BigError")
        action = false
        Drops.show(dropError)
        isPresentingScanner=false
    }
    let dropError = Drop(
        title: "Erreur",
        subtitle: "Identifiant ou mot de passe incorrect",
        icon: UIImage(systemName: "clear.fill"),
        action: .init {
            print("Drop tapped")
            Drops.hideCurrent()
        },
        position: .bottom,
        duration: 5.0,
        accessibility: "Alert: Title, Subtitle"
    )
    struct QRCodeDecode: Decodable {
        let username: String
        let password: String
    }
    
    
    let decoder = JSONDecoder()
    
    @State private var saveJWT: String = ""
    @State private var userID:String=""
    @State private var passwordUser:String=""
    @State private var isPresentingScanner:Bool=false
    @State private var scannedCode: String = "envoie"
    
    @State var action: Bool = false
    var request = APIBack()
    
    var body: some View {
        VStack {
            ZStack{
                Color("BlueBackground").ignoresSafeArea()
                VStack{
                    Spacer()
                    Button(action: {
                        isPresentingScanner.toggle()
                    }) {VStack{
                        VStack{
                            Image(systemName: "camera.viewfinder").resizable().frame(width: 150, height: 150 ).foregroundColor(.white)
                        }.padding(.bottom,100)
                    }.padding(.top,100).frame(width: 180, height: 180).background(Color("LogoIconLogin")).cornerRadius(20) .shadow(color: Color("LogoIconLogin"), radius: 20)}
                    
                    Text("Scanner votre carte vendeur").foregroundColor(.white).padding(.top,40).font(.system(size: 24))
                    HStack{
                        VStack{
                            Divider().frame(minHeight:3).background(Color.white).padding()
                        }
                        Text("Ou").foregroundColor(.white).font(.system(size: 24))
                        
                        VStack{
                            Divider().frame(minHeight:3).background(Color.white).padding()
                        }
                    }.padding(.top,20)
                    
                    Text("Entrer votre identifiant").foregroundColor(.white).padding(.vertical,20).font(.system(size: 24))
                    
                    VStack{
                        TextField("Identifiant", text:$userID)  .autocapitalization(.none).disableAutocorrection(true)
                        
                        SecureField("Mot de passe", text:$passwordUser).autocapitalization(.none).disableAutocorrection(true)
                    }.textFieldStyle(.roundedBorder).padding(.horizontal,50).padding(.vertical,20)
                    HStack {
                        NavigationLink(destination: Cart(), isActive: $action) {
                            EmptyView()
                        }
                        Text("Connexion")
                            .onTapGesture {
                                self.signIn()
                            }.padding().foregroundColor(.white).background(Color("LogoIconLogin")).clipShape(RoundedRectangle(cornerRadius: 5))}.padding(.bottom,40)
                    Spacer()
                    Spacer()
                    Spacer()
                }
                
            }
        }
        .sheet(isPresented: $isPresentingScanner) {
            
            CodeScannerView(codeTypes: [.ean13, .qr], showViewfinder: true) { response in
                if case let .success(result) = response {
                    userID=""
                    passwordUser=""
                    scannedCode = result.string
                    //isPresentingScanner = false
                    print("QRCode",scannedCode)
                    do {
                        let jsonData = scannedCode.data(using: .utf8)!
                        let decodeQRcode = try decoder.decode(QRCodeDecode.self, from: jsonData)
                        userID=decodeQRcode.username
                        passwordUser=decodeQRcode.password
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                    request.postAuthenticateByUsername(username: userID,password: passwordUser, delegate: self)
                    
                }
            }
        }
    }
    func   signIn(){
        request.postAuthenticateByUsername(username: userID,password: passwordUser, delegate: self)
        
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
