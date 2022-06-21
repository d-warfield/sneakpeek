

import SwiftUI



// Custom ScrollView With Refresh Control...
struct RefreshableScrollView<Content: View>: UIViewRepresentable {
    
    var content: Content
    var onRefresh: (UIRefreshControl) -> ()
    var refreshControl = UIRefreshControl()
    
    // View Builder to capture SwiftUI View...
    init(@ViewBuilder content: @escaping ()-> Content,onRefresh: @escaping (UIRefreshControl) -> ()) {
        self.content = content()
        self.onRefresh = onRefresh
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        
        let uiscrollView = UIScrollView()
        
        // Refresh Control...
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull Me")
        refreshControl.tintColor = .secondaryLabel
        refreshControl.backgroundColor = .white
        

        
        refreshControl.addTarget(context.coordinator, action: #selector(context.coordinator.onRefresh), for: .valueChanged)
        
        // Since were removing the last subview..
        // so it will remove refresh controll
        // so add after setting up view....
        
        setUpView(uiscrollView: uiscrollView)
        
        uiscrollView.refreshControl = refreshControl
        
        return uiscrollView
        
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        
        // Because view is not updating dynamically...
        // Updating View Dynamically....
        setUpView(uiscrollView: uiView)
    }
    
    func setUpView(uiscrollView: UIScrollView){
        
        // Extraxcting SwiftUI View...
        // Moving View Up...
        let hostView = UIHostingController(rootView: content.frame(maxHeight: .infinity, alignment: .top))
        
        // Were going to constraints System from UIKit..
        // so that no need of width and height calculations...
        hostView.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Cliping the swiftUI view to UIKit View...
        let constraints = [
        
            // Four Corners...
            hostView.view.topAnchor.constraint(equalTo: uiscrollView.topAnchor),
            hostView.view.bottomAnchor.constraint(equalTo: uiscrollView.bottomAnchor),
            hostView.view.leadingAnchor.constraint(equalTo: uiscrollView.leadingAnchor),
            hostView.view.trailingAnchor.constraint(equalTo: uiscrollView.trailingAnchor),
            
            // Size...
            hostView.view.widthAnchor.constraint(equalTo: uiscrollView.widthAnchor),
            // For Bouncing...
            hostView.view.heightAnchor.constraint(greaterThanOrEqualTo: uiscrollView.heightAnchor,constant: 1),
        ]
        // Removing Previously Added View...
        uiscrollView.subviews.last?.removeFromSuperview()
        uiscrollView.addSubview(hostView.view)
        uiscrollView.addConstraints(constraints)
    }
    
    class Coordinator: NSObject{
        
        var parent: RefreshableScrollView
        
        init(parent: RefreshableScrollView) {
            self.parent = parent
        }
        
        @objc func onRefresh(){
            parent.onRefresh(parent.refreshControl)
        }
    }
}



