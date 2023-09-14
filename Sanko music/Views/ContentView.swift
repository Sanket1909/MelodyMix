//
//  ContentView.swift
//  Sanko music
//
//  Created by Sanket Patel  on 2022-04-03.
//

import SwiftUI
import Firebase



struct ContentView: View {
    
    let didCompletedLoginProcess: () -> ()
    
    
    @State private var isLoginMode = false
        @State private var email = ""
        @State private var password = ""
        @State private var shouldShowImagePicker = false
    
    
    var body: some View {
       
            NavigationView {
                ScrollView {
                    
                    VStack(spacing: 16) {
                        Picker(selection: $isLoginMode, label: Text("Picker here")) {
                            Text("Login")
                                .tag(true)
                            Text("Sign Up")
                                .tag(false)
                        }.pickerStyle(SegmentedPickerStyle()).shadow(color: Color.black, radius: 5,x:5,y:5)
                        
                        if !isLoginMode{
                            Button {
                                shouldShowImagePicker
                                    .toggle()
                            } label: {
                                
                                VStack {
                                    if let image = self.image{
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 130 ,height: 130)
                                            
                                            .cornerRadius(64)
                                    }else{
                                        
                                        Image("Image-1")
                                            .resizable()
                                            .frame(width:150.0,height: 150.0)
                                            .padding()
                                    }
                                }
                                .overlay(RoundedRectangle(cornerRadius: 65)
                                    .stroke(Color.black,lineWidth: 4)).shadow(color: Color.black, radius: 5,x:5,y:5)
                                
                                
                            }}
                        
                        Group {
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            SecureField("Password", text: $password)
                        }
                        .padding(12)
                        .background(Color.white)
                        .shadow(color: Color.black, radius: 5,x:5,y:5)
                        Button {
                            
                            handleAction()
                        } label: {
                            HStack {
                                Spacer()
                                Text(isLoginMode ? "Log In" : "Sign Up")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 14, weight: .semibold))
                                Spacer()
                            }.background(Color.red).shadow(color: Color.black, radius: 5,x:5,y:5)
                            
                        }
                    }
                    .padding()
                    
                }
                .navigationTitle(isLoginMode ? "Log In" : "Sign Up")
                .background(Color(.init(white: 0, alpha: 0.05))
                    .ignoresSafeArea())
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil){
                ImagePicker(image: $image)
            }
        }
    
    @State var image: UIImage?

    private func handleAction() {
            if isLoginMode {
                loginUser()
            } else {
                createNewAccount()
            }
        }

        private func loginUser() {
            FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
                if let err = err {
                    print("Failed to login user:", err)
                    self.loginStatusMessage = "Failed to login user: \(err)"
                    return
                }else{

                print("Successfully logged in as user: \(result?.user.uid ?? "")")

                self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
                    self.didCompletedLoginProcess() }
            }
        }
    

        @State var loginStatusMessage = ""

        private func createNewAccount() {
            FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
                if let err = err {
                    print("Failed to create user:", err)
                    self.loginStatusMessage = "Failed to create user: \(err)"
                    return
                }

                print("Successfully created user: \(result?.user.uid ?? "")")

                self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
                self.persistImageToStorage()
            }
        }
    private func persistImageToStorage() {
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            let ref = FirebaseManager.shared.storage.reference(withPath: uid)
            guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
            ref.putData(imageData, metadata: nil) { metadata, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to push image to Storage: \(err)"
                    return
                }

                ref.downloadURL { url, err in
                    if let err = err {
                        self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                        return
                    }

                    self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                    print(url?.absoluteString)
                     
                    guard let url = url else { return }
                    self.storeUserInformation(imageProfileUrl:url)
                }
            }
        }
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["email": self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    self.loginStatusMessage = "\(err)"
                    return
                }

                print("Success")
            }
    }
    
    }

struct Contenview_Previews: PreviewProvider{
    static var previews: some View{
        ContentView(didCompletedLoginProcess: {
            
        }) .environmentObject(AudioManager())
    }
}

