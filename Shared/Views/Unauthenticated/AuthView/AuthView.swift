//
//  CodeView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/9/22.
//

import SwiftUI

struct AuthView: View {
    
    @State private var secret = ""
    @State private var isLoading = true
    @EnvironmentObject private var auth: AuthViewModel
    @EnvironmentObject var user: UserFetchServiceResultModel
    @EnvironmentObject var banking: BankingServiceModel
    @EnvironmentObject var inbox: InboxServiceModel
    @FocusState private var isFocused: Bool
    var phoneNumber: String

    
    var body: some View {
        VStack {
            HStack {
                if auth.isVerifyingCode {
                    VStack(alignment: .leading) {
                        Text("Verifying your code")
                            .font(.system(size: 26, weight: .bold, design: .default))
                        Text("Working some magic")
                            .foregroundColor(.secondary)
                            .font(.system(size: 18, weight: .regular))
                            .padding(.top, 4)
                    }
                    ProgressView()
                        .padding()
                    Spacer()
                } else {
                    if auth.isAuthLoading {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Sending you a code")
                                    .font(.system(size: 26, weight: .bold, design: .default))
                                Text("Sent code to: \(phoneNumber)")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 18, weight: .regular))
                                    .padding(.top, 4)
                            }
                            ProgressView()
                                .padding()
                        }
                        Spacer()
                    } else {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Enter your code")
                                    .font(.system(size: 26, weight: .bold, design: .default))
                                TextField(
                                    "Your secret code",
                                    text: $secret
                                )
                                .focused($isFocused)
                                .onAppear {
                                    
                                    if !self.isFocused {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        self.isFocused = true
                                    }
                                    }
                                }
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .border(.clear)
                                .font(.system(size: 20, weight: .medium, design: .default))
                                .textContentType(.oneTimeCode)
                                .keyboardType(.numberPad)
                                .onChange(of: secret) {
                                    if (secret.count >= 6 && secret.count <= 6) {
                                        print($0)
                                        Task {
                                            let response = try await auth.verifyCode(phoneNumber: phoneNumber, secret: secret)
                                            
                                            print("AUTH RESPONSE ----->", response)
                                            
                                            if response {
                                                try await user.fetchUser()
                                                try await banking.fetchBanking()
                                                try await inbox.fetchReceived()
                                                auth.isAuthenticated = true
                                            }
                                            
                                            
                                            self.secret = ""
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding()

            Spacer()
        }
        .task {
            
            if !auth.didSendCode {
                try! await auth.initAuth(phoneNumber: phoneNumber)
            }
            
            


        }
        
        

    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(phoneNumber: "")
            .environmentObject(UserFetchServiceResultModel())
    }
}
