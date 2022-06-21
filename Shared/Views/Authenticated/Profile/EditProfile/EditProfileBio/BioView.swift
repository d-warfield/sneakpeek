
//
//  DisplayNameView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/11/22.
//

import SwiftUI

struct BioView: View {
    @Environment(\.dismiss) var dismiss

    
    @State private var bio = ""
//    @FocusState private var isFocused: Bool = false
    @EnvironmentObject var user: UserFetchServiceResultModel



    
    var body: some View {
        
            
                
            VStack {
                VStack(alignment: .leading, spacing: 14) {
                TextField(
                    "\(user.userData.bio ?? "Bio")",
                    text: $bio
                )
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .onAppear{
                    self.bio = user.userData.bio!
                }
                .onChange(of: bio) { newValue in
                    if newValue.count > 65 {
                        self.bio = String(newValue.prefix(65))
                    }
                }
                    Divider()
                     .frame(height: 1)

//                .focused($isFocused)
                    Text("\(bio.count)/65")
                        .font(.system(.caption))
                        .foregroundColor(.secondary)
                Spacer()
                
                }
                .padding(20)

            }
            .background(Color("listBackground"))

            .navigationBarTitle("Bio", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            try await user.updateBio(bio: bio)
                        }
                        dismiss()

                    } label: {
                        Text("Save")
                    }
                } 
        }
    }
}

struct BioView_Previews: PreviewProvider {
    static var previews: some View {
        BioView()
    }
}
