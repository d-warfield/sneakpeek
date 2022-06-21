//
//  DisplayNameView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/11/22.
//

import SwiftUI

struct DisplayNameView: View {
    @Environment(\.dismiss) var dismiss
    @State private var displayName = ""
    @EnvironmentObject var user: UserFetchServiceResultModel
    
    @FocusState private var isFocused: Bool

    
    
    
    
    var body: some View {
        
        
        
        VStack {
            
            VStack(alignment: .leading, spacing: 14) {
                TextField(
                    "\(user.userData.displayName ?? "Display Name")",
                    text: $displayName
                    
                )
                .textInputAutocapitalization(.words)
                .disableAutocorrection(true)
                .textFieldStyle(.plain)
                .onAppear{
                    self.displayName = user.userData.displayName!
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.isFocused = true

                    }
                    

                }
                .focused($isFocused)

                .onChange(of: displayName) { newValue in
                    if newValue.count > 25 {
                        self.displayName = String(newValue.prefix(25))
                    }
                }
                Divider()
                 .frame(height: 1)
                
                VStack(alignment: .leading, spacing: 14) {
                    
                    Text("\(displayName.count)/25")
                        .font(.system(.caption))
                        .foregroundColor(.secondary)
                        
                    Text("Your display name will show in people's inbox")
                        .font(.system(.caption))
                        .foregroundColor(.secondary)
                }
              
                
                
                
                //                .focused($isFocused)
                Spacer()
            }
            .padding(20)
            
            
            
            
        }
        .background(Color("listBackground"))
        .navigationBarTitle("Display Name", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        try await user.updateDisplayName(displayName: displayName)
                    }
                    dismiss()

                } label: {
                    Text("Save")

                        
                }
                
            

                
            }
            
            
            
            
            
        }
    }
}

struct DisplayNameView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayNameView()
            .environmentObject(UserFetchServiceResultModel())

    }
}
