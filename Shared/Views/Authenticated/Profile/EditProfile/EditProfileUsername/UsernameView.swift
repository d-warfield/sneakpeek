//
//  DisplayNameView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/11/22.
//

import SwiftUI

struct UsernameView: View {
    @Environment(\.dismiss) var dismiss
    
    
    @EnvironmentObject var user: UserFetchServiceResultModel

    
    @State private var username = ""
    @FocusState private var isFocused: Bool

    
   
    
    
    
    
    var body: some View {
        
        
        
        VStack {
            
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 2) {
                    Text("@")
                    TextField(
                        "\(user.userData.username ?? "Username")",
                        text: $username
                    )
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                 
                    .focused($isFocused)
                    .onAppear {
                        
                        self.username = user.userData.username!
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.isFocused = true

                        }
                    }
                    .onChange(of: username) { newValue in
                      
                        username = newValue.replacingOccurrences(of: " ", with: "")
                        if newValue.count > 25 {
                            self.username = String(newValue.prefix(25))

                        }
                    }
                }
              
                Divider()
                 .frame(height: 1)
                
                Text("\(username.count)/25")
                    .font(.system(.caption))
                    .foregroundColor(.secondary)
            }
            .padding(20)

            
            
            
            Spacer()
            
            
        }
        .background(Color("listBackground"))
        .navigationBarTitle("Username", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        if username.count > 0 {
                            try await user.updateUsername(username: username)
                        }
                    }
                    dismiss()

                    
                } label: {
                    Text("Save")
                }
            }
            
            
            
            
        }
    }
}

struct UsernameView_Previews: PreviewProvider {
    static var previews: some View {
        UsernameView()
    }
}
