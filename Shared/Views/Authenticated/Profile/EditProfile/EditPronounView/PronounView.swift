//
//  PronounView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/11/22.
//

import SwiftUI

struct PronounView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var pronoun = ""
    //    @FocusState private var isFocused: Bool = false
    @EnvironmentObject var user: UserFetchServiceResultModel
    
    let names = ["He/him/his", "He", "Her", "Hir", "She/her/hers", "Ae", "Ae/aer/aers", "Ela/dela", "Fae", "They", "She", "Ey", "E", "Ey", "Them", "Hu","Peh","Per", "Thon", "Jee","Ve","Xe", "Ze","Zhim", "Themself", "Herself", "Himself"]
    
    
    
    
    
    var body: some View {
        VStack {
            List {
                ForEach(names, id: \.self) { name in
                    Button {
                        self.pronoun = name.lowercased()
                        
                    } label: {
                        HStack {
                            
                            
                            Text(name.lowercased())
                                .foregroundColor(.primary)
                            Spacer()
                            if name.lowercased() == self.pronoun {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
                
                Section {
                    Button {
                        
                        self.pronoun = ""
                        
                    } label: {
                        HStack {
                            
                            
                            Spacer()
                            Text("Remove Pronoun")
                                .foregroundColor(Color.red)
                            Spacer()
                        }
                        .frame(width: .infinity)
                    }
                }
                
            }
            .listStyle(.automatic)
            
        }
        .onAppear(perform: {
            self.pronoun = user.userData.pronoun!.lowercased()
        })
        .navigationBarTitle("Pronoun", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                    
                    Task {
                        try await user.updatePronoun(pronoun: pronoun)
                    }
                } label: {
                    Text("Save")
                }
            }
            
            //        .background(Color("listBackground"))
            
            
        }
        
        
        
    }
    
    var searchResults: [String] {
        if pronoun.isEmpty {
            return names
        } else {
            return names.filter { $0.contains(pronoun) }
        }
    }
}

struct PronounView_Previews: PreviewProvider {
    static var previews: some View {
        PronounView()
            .environmentObject(UserFetchServiceResultModel())
    }
}


