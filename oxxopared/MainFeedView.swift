//
//  MainFeedView.swift
//  oxxopared
//
//  Created by Dicka J. Lezama on 24/04/24.
//

import SwiftUI

struct MainFeedView: View {
    @State var selectedTab: MainTabBarItem = .announcements  // Using MainTabBarItem now

    var body: some View {
        ZStack {
            VStack{
                ZStack(alignment: .top) {
                    MainTabBarContainerView(selection: $selectedTab) {
                        TabView(selection: $selectedTab) {
                            Feed()
                                .environmentObject(SpotStore())
                                .tag(MainTabBarItem.announcements)
                                .mainTabBarItem(tab: .announcements, selection: $selectedTab)
                            
                            SpotsARView()
                                .tag(MainTabBarItem.ar)
                                .mainTabBarItem(tab: .ar, selection: $selectedTab)
                            
                            ProfileView()
                                .tag(MainTabBarItem.profile)
                                .mainTabBarItem(tab: .profile, selection: $selectedTab)
                        }
                        .ignoresSafeArea(.all)
                    }
                    .navigationBarBackButtonHidden(true)
                }
            }
        }
        
    }
}

struct MainFeedView_Previews: PreviewProvider {
    static var previews: some View {
        MainFeedView()
            .environmentObject(SpotStore())
    }
}
