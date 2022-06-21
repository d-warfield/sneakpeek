import Foundation
import SwiftUI


struct TabBarView: View {
    @EnvironmentObject var camera: CameraModel
    @Binding var currentTab: Int
    @Namespace var namespace
    
    
    var tabBarOptions: [String] = ["message.fill", "camera.fill", "person.crop.circle.fill"]
    
    
    
    var body: some View {
        
        if !camera.isTaken    {
            
            let _ = print(camera.isRecording)
            
            
            ScrollView(.vertical, showsIndicators: false) {
                
                
                HStack {
                    
                    
                    ForEach(Array(zip(self.tabBarOptions.indices,
                                      self.tabBarOptions)),
                            id: \.0,
                            content: {
                        index, name in
                        
                        
                        
                        HStack {
                            
                            
                            TabBarItem(currentTab: self.$currentTab,
                                       namespace: namespace.self,
                                       tabBarItemName: name,
                                       
                                       tab: index)
                            
                        }
                        //                    .background(.pink)
                        
                        
                    })
                }
                .padding(.horizontal)
                
                
                
                
                
                
            }
           
            
            
            
            //        .background(.pink)
            
            
            
            .frame(maxWidth: .infinity)
            .frame(height:  UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 55 : 55)
            .padding(.bottom, 30 )
            
        }
        
    }
}

extension View {
    // 1 Create a ViewBuilder function that can be applied to any type of content conforming to view
    @ViewBuilder func conditionalModifier<Content: View>(_ condition: Bool,
                                                         transform: (Self) -> Content) -> some View {
        if condition {
            // 2 If condition matches, apply the transform
            background(.pink)
        } else {
            // 3 If not, just return the original view
            self
        }
    }
}


struct TabBarItem: View {
    
    
    @EnvironmentObject var user: UserFetchServiceResultModel
    @EnvironmentObject var inbox: InboxServiceModel
    
    
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    
    var tabBarItemName: String
    var tab: Int
    @State var unopenedCount: Int?
    
    

    
    
    private func backgroundColor(for addressType: Int) -> Color {
        
        if user.userData.accountType == "creator" {
            switch (currentTab) {
            case 0: return currentTab == tab ? .black : Color.black.opacity(0.5)
            case 1: return currentTab == tab ? .white : Color.white.opacity(0.5)
            case 2: return currentTab == tab ? .black : Color.black.opacity(0.5)
            default:
                return .pink
            }
        } else {
            
            
            
            switch (currentTab) {
            case 0: return currentTab == tab ? .black : Color.black.opacity(0.5)
            case 1: return currentTab == tab ? .black : Color.black.opacity(0.5)
            case 2: return currentTab == tab ? .black : Color.black.opacity(0.5)
            default:
                return .pink
            }
        }
    }
    
    
    
    
    
    
    var body: some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack {
                
                
                ZStack(alignment: .center) {
                    
                    if inbox.receivedResults.filter{ $0.notificationType == "received" && $0.opened! == false }.count > 0 {
                        
                    
                    
                    if tabBarItemName == "message.fill" && inbox.receivedResults.contains(where: {$0.opened == false } )
                    {
                        
                        ZStack(alignment: .center) {
                            Text("\(inbox.receivedResults.filter{ $0.notificationType == "received" && $0.opened! == false }.count ?? 0)")
                                .foregroundColor(.white)
                                .zIndex(2)
                                .font(.caption2.bold())
                            Circle()
                            
                                .foregroundColor(.pink)
                            
                        }
                        .zIndex(1)
                        .frame(width: 16, height: 16, alignment: .center)
                        .position(x: 38, y: 20)
                        
                        
                    }
                    }
                    
                    Image(systemName: tabBarItemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: tabBarItemName == "camera.fill" ? 28 : 25, height: tabBarItemName == "camera.fill" ? 28 : 25, alignment: .center)
                        .foregroundColor(backgroundColor(for: currentTab))
                        .zIndex(0)
                    
                    
                    
                    
                    
                    switch tabBarItemName {
                    case "message.fill":
                        Text("Inbox")
                            .font(.caption2.bold())
                            .padding(.top, 50)
                            .foregroundColor(backgroundColor(for: currentTab))
                    case "camera.fill":
                        Text("Camera")
                            .font(.caption2.bold())
                            .padding(.top, 50)
                            .foregroundColor(backgroundColor(for: currentTab))
                    case "person.crop.circle.fill":
                        Text("Me")
                            .font(.caption2.bold())
                            .padding(.top, 50)
                            .foregroundColor(backgroundColor(for: currentTab))
                        
                        
                    default: Text("")
                        
                        
                    }
                    
                }
                //                .background(.green)
                .frame(minWidth: 50, maxWidth: 50, minHeight: 50, maxHeight: 50)
                
                //                .conditionalModifier(currentTab == 1) {
                //
                //
                //                    $0.background()
                //
                //                }
                
                //
                //
                //                if currentTab == tab {
                //                    Color.white
                //                        .frame(width: 5,height: 5)
                //                        .cornerRadius(100)
                //
                //                        .matchedGeometryEffect(id: "underline",
                //                                               in: namespace,
                //                                               properties: .frame)
                //
                //                } else {
                //                    Color.clear.frame(width: 5,height: 5)
                //                }
            }
            //            .animation(.spring(), value: self.currentTab)
            .frame(maxWidth: .infinity)
            
        }
        .buttonStyle(.plain)
        
        
    }
}
