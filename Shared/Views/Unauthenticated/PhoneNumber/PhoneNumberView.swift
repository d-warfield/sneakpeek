//
//  PhoneNumberView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/9/22.
//

import SwiftUI


struct PhoneNumberView: View {
    @State var isLinkActive = false
    @State private var phoneNumber = ""
    @State private var countryCode = "+1"
    @State private var showingSheet = false
    @State private var disabledDueToLetters = false
    
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    @FocusState private var isFocused: Bool
    
    
   
    


    
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Enter your phone number")
                    .font(.system(size: 26, weight: .bold, design: .default))
                HStack {
                    HStack {
                        Button {
                            showingSheet.toggle()
                            
                            
                        } label: {
                            HStack {
                                Text("\(countryCode)")
                                    .font(.system(size: 20, weight: .medium, design: .default))
                                    .foregroundColor(.black)
                                Triangle()
                                    .fill(.black)
                                    .rotationEffect(.degrees(-180))
                                
                                
                                    .frame(width: 13, height: 9)
                            }
                            
                            
                        }
                        .sheet(isPresented: $showingSheet) {
                            SheetView(countryCode: $countryCode)
                        }
                    }
                    
                    TextField(
                        "Phone Number",
                        text: $phoneNumber
                    )
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .border(.clear)
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .keyboardType(.numberPad)
                    .onChange(of: self.phoneNumber) { newValue in
                        let letters = NSCharacterSet.letters
                        let range = phoneNumber.rangeOfCharacter(from: letters)
                        if let test = range {
                            self.disabledDueToLetters = true
                        }
                        else {
                            self.disabledDueToLetters = false

                        }
                                }
                    
                    .focused($isFocused)
                    .onAppear {
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.isFocused = true
                            
                        }
                    }
                    
                    
                    
                    
                    
                }
                
                Spacer()
                
            }
            .padding()
            
            VStack(alignment: .center) {
                HStack {
                    NavigationLink(destination: AuthView(phoneNumber: countryCode + phoneNumber)) {
                        
                        Text("Send code")
                    
                    }
                    .disabled(self.phoneNumber.isEmpty || self.phoneNumber.count < 5 || disabledDueToLetters)
                    .buttonStyle(DefaultButtonStyle())

                }
                
                
                Text("You agree to our [privacy policy](https://influencer-backend-prod-legal.s3.us-east-2.amazonaws.com/PrivacyPolicy.txt) and our [terms of service](https://influencer-backend-prod-legal.s3.us-east-2.amazonaws.com/TermsAndConditions.txt)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 6)
                Text("Sms fees may apply")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 15)
                
                
            }
            
            
            
            
            
        }
    }
}



struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView()
    }
}


struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var countryCode: String
    @State var searchQuery = ""
    
    
    
    
    var body: some View {
        
        VStack {
            
            Button("Tap your country") {
                dismiss()
            }
            .font(.headline)
            .padding()
            .foregroundColor(.black)
            
            
            List {
                ForEach(countries, id: \.id) { country in
                    
                    Button {
                        countryCode = country.countryCode
                        dismiss()
                    } label: {
                        HStack {
                            
                            
                            
                            Text("\(country.name)")
                                .font(.body)
                            Spacer()
                            Text("\(country.countryCode)")
                                .font(.subheadline).bold()
                            
                        }
                        
                    }
                    
                    
                    
                }
            }
            .listStyle(.plain)
            
            
            
        }
        
        
    }
}


struct Country: Identifiable, Codable {
    enum CodingKeys: CodingKey {
        case name
        case countryCode
        case isoCode
        case flag
        
    }
    var id = UUID()
    var name: String
    var countryCode: String
    var isoCode: String
    var flag: String
}


struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}
