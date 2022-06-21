import UIKit

class Haptics {
    static let shared = Haptics()
    
    private init() { }

    func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }
    
    func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
}


//Haptics.shared.play(.heavy)
//Haptics.shared.play(.light)
//Haptics.shared.play(.medium)
//Haptics.shared.play(.rigid)
//Haptics.shared.play(.soft)
//
//Haptics.shared.notify(.error)
//Haptics.shared.notify(.success)
//Haptics.shared.notify(.warning)
