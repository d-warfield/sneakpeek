//
//  ContentView.swift
//  Shared
//
//  Created by Dennis Warfield on 4/9/22.
//

import SwiftUI

var API_URL = Bundle.main.object(forInfoDictionaryKey: "API_URL")!

struct ContentView: View {
    @StateObject var user = UserFetchServiceResultModel()
    @StateObject var search = SearchForUserModel()
    @StateObject var banking = BankingServiceModel()
    @StateObject var inbox = InboxServiceModel()
    @StateObject var product = ProductService()
    @StateObject var auth = AuthViewModel()
    @StateObject var camera = CameraModel()
    
    @State var currentTab: Int = 0
    @State var isLoading = true
    
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
        UINavigationBar.changeAppearance(clear: true)
        
        
    }
    
    var body: some View {
        if isLoading {
            ZStack {
                Image(systemName: "eyes")
                    .font(.system(size:50))
                    
            }
            .environment(\.colorScheme, .dark)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .background(.black)
            
            .onAppear {
                auth.checkAuthStatus()
                
                Task {
                    if auth.isAuthenticated {

                        do {
                            try await user.fetchUser()
                            
                            if user.userData.accountType == "creator" {
                                
                                self.currentTab = 1
                                camera.Check()
//                                camera.setUp()
                            } else {
                                self.currentTab = 0
                                
                            }
                            
//

                            
                            
                            
                            
                        } catch let error as NSError {
                            print("Fail: \(error.localizedDescription)")
                        } catch {
                            print("Fail: \(error)")
                        }
                    } else {
                        print("NOT SIGNED IN")
                    }
                    self.isLoading = false
                    try await inbox.fetchReceived()

                }
            }
            
        } else {
            Group {
                if !auth.isAuthenticated {
                    LandingView()
                        .environmentObject(auth)
                        .environmentObject(user)
                        .environmentObject(banking)
                        .environmentObject(inbox)
                        .accentColor(.black)

                    
                    
                } else {
                    NavigationView {
                        ZStack(alignment: .bottom) {
                            
                            TabView(selection: self.$currentTab) {
                                InboxView()
                                    .tag(0)
                                    
                                
                                CameraView(currentTab: self.$currentTab)
                                    .tag(1)
                                    
                                
                                PrimaryProfileView()
                                    .tag(2)
                                
                            }
                            

                            
                            
                            TabBarView(currentTab: self.$currentTab)
                                .background(self.currentTab == 1 ? user.userData.accountType == "creator" ? .black : .white : .white)
                        }
                        .edgesIgnoringSafeArea(self.currentTab == 1 && user.userData.accountType == "creator" ? .vertical : .bottom)
                        //                        .background(currentTab == 0 ? .white : Color("listBackground"))
                        
                    }
                    .accentColor(.black)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .environmentObject(user)
                    .environmentObject(search)
                    .environmentObject(banking)
                    .environmentObject(inbox)
                    .environmentObject(product)
                    .environmentObject(auth)
                    .environmentObject(camera)
                }
            }
            
        }
        
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



extension UINavigationBar {
    static func changeAppearance(clear: Bool) {
        let appearance = UINavigationBarAppearance()
        
        if clear {
            appearance.configureWithTransparentBackground()
        } else {
            appearance.configureWithDefaultBackground()
        }
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}



