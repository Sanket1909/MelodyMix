//
//  MainMessagesView.swift
//  Sanko music
//
//  Created by Sanket Patel  on 2022-04-04.
//

import SwiftUI

struct ChatUser {
    let uid,email,profileImageUrl:String
}

class MainMessagesViewModel: ObservableObject{
    
    @Published var errorMessage = ""
        @Published var chatUser: ChatUser?
    @Published var isUserCurrentlyLoggedout = false
    init(){
        DispatchQueue.main.async {
            self.isUserCrrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
            fetchCurrentUser()
        
        
    }
     func fetchCurrentUser(){
        
       

                guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
                    self.errorMessage = "Could not find firebase uid"
                    return
                }

                FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
                    if let error = error {
                        self.errorMessage = "Failed to fetch current user: \(error)"
                        print("Failed to fetch current user:", error)
                        return
                    }

                    guard let data = snapshot?.data() else {
                        self.errorMessage = ""
                        return

                    }
                    let uid = data["uid"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let profileImageUrl = data["profileImageUrl"] as? String ?? ""
                    self.chatUser = ChatUser(uid: uid, email: email, profileImageUrl: profileImageUrl)
                }
    }
     @Published var isUserCrrentlyLoggedOut = false
    func handleSignOut(){
        
        isUserCrrentlyLoggedOut.toggle()
       try? FirebaseManager.shared.auth.signOut()
        
    }
}

struct MainMessagesView: View {
    
    @State var shouldShowLogOutOptions = false
    @ObservedObject private var  vm = MainMessagesViewModel()
    
    private var customNavBar: some View {
        
        HStack(spacing: 16) {
            
            Image( "Image-4")
                .resizable()
                .frame(width:50, height: 50)
                .font(.system(size: 34, weight: .heavy))
                .shadow(color: Color.black, radius: 5,x:5,y:5)
            VStack(alignment: .leading, spacing: 4) {
                Text("Music App")
                    .font(.system(size: 24, weight: .bold))
                    
                
                
            }
            
            Spacer()
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
                    .shadow(color: Color.black, radius: 5,x:5,y:5)
            }
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("Are You Sure?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("handle sign out")
                    vm.handleSignOut()
                }),
                .cancel()
            ])
        }
        
        .fullScreenCover(isPresented: $vm.isUserCrrentlyLoggedOut,onDismiss: nil){
            ContentView(didCompletedLoginProcess: {
                self.vm.isUserCrrentlyLoggedOut = false
                self.vm.fetchCurrentUser()
            })
        }
    }
    
    var body: some View {
            ZStack {
                // Gradient background
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.8, green: 0.8, blue: 0.8), Color(red: 0.6, green: 0.6, blue: 0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Sanket \(vm.errorMessage)")
                    customNavBar
                    messagesView
                }
                .padding(.bottom, 50)
            }
        }
    
    //@StateObject var shakiraVM: MeditationViewModel
    @State private var showPlayer = false
    @StateObject var shakiraVM: MeditationViewModel = MeditationViewModel(artists: artistsData)
    
    private var messagesView: some View {
        ScrollView {
            ForEach(shakiraVM.artists, id: \.name) { artist in
                VStack {
                    HStack(spacing: 16) {
                        Image(artist.image)
                            .resizable()
                        //.font(.system(size: 32))
                            //.shadow(color: Color("Color1").opacity(0.6), radius: 5,x:5,y:5)
                            .shadow(color: Color.black, radius: 5,x:5,y:5)
                            .scaledToFit()
                            .frame(width: 50,height: 50)
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 44)
                                .stroke(Color(.label), lineWidth: 1)
                            )
                        
                        
                        VStack(alignment: .leading) {
                            Text(artist.name)
                                .font(.system(size: 16, weight: .bold))
                            Text("Latest song")
                                .font(.system(size: 14))
                                .foregroundColor(Color.black)
                        }
                        Spacer()
                        Button {
                            showPlayer = true
                            shakiraVM.selectedArtist = artist
                        } label :{
                            
                            Image("Image-3")
                                .resizable()
                                .frame(width:70,height: 70)
                                //.shadow(color: Color("Color1").opacity(0.6), radius: 5,x:5,y:5)
                                .shadow(color: Color.black, radius: 5,x:5,y:5)
                            
                        }
                        
                        
                        
                    } .onTapGesture {
                        // Update the selected artist when a row is tapped
                        shakiraVM.selectedArtist = artist
                    }
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
                
            }.padding(.bottom, 50)
                .ignoresSafeArea()
                .fullScreenCover(item: $shakiraVM.selectedArtist) { artist in
                                   SwiftUIView(selectedArtist: artist)
                               }
        }
    }
    
    
    
    
    
    struct MainMessagesView_Previews: PreviewProvider {
        static var shakiraVM = MeditationViewModel(artists: artistsData)
        static var previews: some View {
            
            MainMessagesView( shakiraVM: shakiraVM)
                .environmentObject(AudioManager())
        }
    }
    
}
