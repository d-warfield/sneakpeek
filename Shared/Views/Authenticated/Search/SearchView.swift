//
//  SearchView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/12/22.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var service: SearchForUserModel
    @EnvironmentObject var user: UserFetchServiceResultModel
    @State var searchQuery = ""
    @State var isNavigationBarHidden: Bool = true
    @State var isLinkActive = false
    
    
    @FocusState private var isFocused: Bool

    

    
    
    
    
    
    var body: some View {
        
        VStack {
            
          
                
                HStack {
                    

                    Image(systemName: "chevron.left")
                        .padding(.trailing, 5)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.black)
                        .onTapGesture {
                               // set item.code & success flag to some view model and then
                               // just call dismiss to return to ViewA
                               dismiss()
                           }

                    
                    HStack {
                         Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                            .padding([.leading], 6)
                            .font(.system(size: 20))
                        
                        
                        
                        TextField("Search", text: $searchQuery)
                            .onChange(of: searchQuery) {
                                print($0)
                                Task {
                                    try await service.triggerSearch(username: searchQuery)
                                }
                            }
                            .textFieldStyle(.automatic)
                            .focused($isFocused)
                        
                        
                        
                    }
                    .frame(minHeight: 36)
                    .background(Color.secondary.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
                .padding()

            if service.isLoading {
                ProgressView()
            } else {
        
                
                List {
                    
                    ForEach(service.searchResults, id: \.self) { result in
                        
                        Button {
                            
                            Task {
                                user.isLoading = true
                                try await user.fetchOtherUser(userId: result.userId!)
                                
                            }
                            self.isLinkActive = true
                            
                        } label: {
                            
                            HStack {
                                AsyncImage(url: URL(string:  result.profilePictureUrl!)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 45, height: 45)
                                        .cornerRadius(1000)
                                        .foregroundColor(.secondary)
                                }
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 45, height: 45)
                                .cornerRadius(1000)
                                
                                VStack(alignment: .leading) {
                                    Text(result.displayName!)
                                        .font(.system(.headline))
                                    Text("@\(result.username!)")
                                        .font(.system(.subheadline))
                                        .foregroundColor(.secondary)
                                        .textCase(.lowercase)

                                }
                                Spacer()
                                
                            }
                            .background(
                                NavigationLink(destination: SecondaryProfileView(), isActive: $isLinkActive) {
                                    EmptyView()
                                }
                                    .hidden()
                            )
                            
                            
                            
                        }
                    }
                }
                .listStyle(.plain)
                
                
            }
            Spacer()

            
        }
        .onAppear {
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isFocused = true
                
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        
        .navigationBarHidden(true)
        .navigationBarTitle("")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(SearchForUserModel())
    }
}
