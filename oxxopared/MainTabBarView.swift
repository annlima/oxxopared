import SwiftUI

struct MainFeedView: View {
    @State var selectedTab: MainTabBarItem = .announcements  // Using MainTabBarItem now

    var body: some View {
        MainTabBarContainerView(selection: $selectedTab) {
            TabView(selection: $selectedTab) {
                Feed()
                    .tag(MainTabBarItem.announcements)
                    .mainTabBarItem(tab: .announcements, selection: $selectedTab)
                
                Feed()
                    .tag(MainTabBarItem.ar)
                    .mainTabBarItem(tab: .ar, selection: $selectedTab)
                
                Feed()
                    .tag(MainTabBarItem.profile)
                    .mainTabBarItem(tab: .profile, selection: $selectedTab)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct MainFeedView_Previews: PreviewProvider {
    static var previews: some View {
        MainFeedView()
    }
}
