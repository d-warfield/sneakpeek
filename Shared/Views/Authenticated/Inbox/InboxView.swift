//
//  InboxView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/9/22.
//

import SwiftUI

struct InboxView: View {
    
    @EnvironmentObject var user: UserFetchServiceResultModel
    @EnvironmentObject var inbox: InboxServiceModel
    @State private var showAlert = false
    @State var dummyOpened = false
    @State private var animate = true
    

    
    
    
    
    
    func actionSheet() {
        guard let data = URL(string: "https://www.sneakpeek.to/@\(user.userData.username!)") else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    func shareApp() {
        let sms = "sms:&body=Hey! Check out this app! www.sneakpeek.to"
        let strURL = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL(string: strURL)!, options: [:], completionHandler: nil)
    }
    
    
    var body: some View {
        
        
        VStack {
            
            
            
            if inbox.isLoading {
                VStack {
                    
                    
                    ProgressView()
                    
                }
            } else {
                VStack {
                    
                    
                    if inbox.receivedResults.count == 0 && Int(NSDate().timeIntervalSince1970) < user.userData.createdAt! + 86400 {
                        
                        VStack(alignment: .leading) {
                            
                            List {
                                
                                
                                DummyInboxItemView(dummyOpened: $dummyOpened)
                                
                            }
                            .padding(.top, 12)
                            .listStyle(.plain)
                            .refreshable {
                                
                                Task {
                                    try await inbox.fetchReceived()
                                }
                                
                            }
                            
                            Spacer()
                        }
                        
                        
                    } else {
                        
                        if inbox.receivedResults.count == 0 {
                            
                            GeometryReader { geo in
                                
                                
                                List {
                                    Text("Your inbox is empty")
                                        .frame(minWidth: geo.size.width, maxWidth: .infinity, minHeight: geo.size.height, maxHeight: .infinity)
                                        .listRowInsets(EdgeInsets())
                                        .listRowSeparator(.hidden)
                                    
                                    
                                    
                                }
                                .listStyle(.plain)
                                .refreshable {
                                    
                                    Task {
                                        try await inbox.fetchReceived()
                                    }
                                    
                                }
                            }
                            
                        } else {
                            List {
                                
                                ForEach(Array(inbox.receivedResults.enumerated()), id: \.offset) { (idx, item) in
                                    
                                    InboxItemView(item: item, index: idx)
                                    
                                }
                                
                            }
                            .padding(.top, 12)
                            .listStyle(.plain)
                            .refreshable {
                                
                                Task {
                                    try await inbox.fetchReceived()
                                }
                                
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
      
        .onDisappear {
            inbox.hasFetchedReceived = true
        }
        .navigationTitle("Inbox")
        .navigationBarTitle("Inbox", displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    shareApp()
                    
                } label: {
                    
                    Image(systemName: "paperplane")
                    
                    
                }
                
                
            }
            ToolbarItem(placement: .navigationBarLeading) {
                
                NavigationLink(destination: SearchView()) {
                    
                    
                    
                    Image(systemName: "magnifyingglass")
                    
                    
                    
                    
                    
                }
                
            }
        }
        
    }
    
    
    
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
    }
}
