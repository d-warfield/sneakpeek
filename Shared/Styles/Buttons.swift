import SwiftUI


struct DefaultButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 200, height: 52, alignment: .center)
            .frame(minWidth: 350)
            .background(.blue)
            .foregroundColor(.white)
            .font(.headline)
            .cornerRadius(14)
            .padding([.bottom], 10)
            .opacity(configuration.isPressed ? 0.7 : 1.0)

        
    }
}


struct InvertedButtonStyleSmall: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .tint(.green)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
        
    }
}





