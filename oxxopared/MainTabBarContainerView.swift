// MainTabBarContainerView.swift
import SwiftUI

// The integrated view that includes the custom TabBarView
struct MainTabBarContainerView<Content: View>: View {
    @Binding var selection: MainTabBarItem
    let content: Content
    @State private var tabs: [MainTabBarItem] = [.announcements, .ar, .profile]
    
    init(selection: Binding<MainTabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                content
            }
            TabBarView1(selectedTab: $selection)
        }
        .onPreferenceChange(MainTabBarItemsPreferenceKey.self) { value in
            self.tabs = value
        }
    }
}

// TabBarView1.swift
struct TabBarView1: View {
    @Binding var selectedTab: MainTabBarItem
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white)
                .shadow(color: .gray.opacity(0.4), radius: 20, x: 0, y: 20)
            
            HStack {
                Spacer(minLength: 0)
                
                ForEach(tabs, id: \.self) { tab in
                    TabButton(tab: tab, selectedTab: $selectedTab, namespace: namespace)
                        .frame(width: 65, height: 65, alignment: .center)
                    
                    Spacer(minLength: 0)
                }
            }
        }
        .frame(height: 70, alignment: .center)
        .padding(.horizontal)
        .edgesIgnoringSafeArea(.all)
    }
    
    private var tabs: [MainTabBarItem] {
        [.announcements, .ar, .profile]
    }
    
    // TabButton is adapted from the provided code to use MainTabBarItem
    private struct TabButton: View {
        let tab: MainTabBarItem
        @Binding var selectedTab: MainTabBarItem
        var namespace: Namespace.ID
        
        var body: some View {
            Button {
                withAnimation {
                    selectedTab = tab
                }
            } label: {
                ZStack {
                    if selectedTab == tab {
                        Circle()
                            .shadow(radius: 10)
                            .background {
                                Circle()
                                    .stroke(lineWidth: 15)
                                    .foregroundColor(tab.color)
                            }
                            .offset(y: -40)
                            .matchedGeometryEffect(id: "Selected Tab", in: namespace)
                            .animation(.spring(), value: selectedTab)
                    }
                    
                    Image(systemName: selectedTab == tab ? tab.selectedImage : tab.imageName)
                        .font(.system(size: 23, weight: .semibold, design: .rounded))
                        .foregroundColor(selectedTab == tab ? .white : .gray)
                        .scaleEffect(selectedTab == tab ? 1 : 0.8)
                        .offset(y: selectedTab == tab ? -40 : 0)
                        .animation(selectedTab == tab ? .spring(response: 0.5, dampingFraction: 0.3, blendDuration: 1) : .spring(), value: selectedTab)
                }
            }
            .buttonStyle(.plain)
        }
    }
}

struct MainTabBarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarContainerView(selection: .constant(.announcements)) {
            Color.clear // Placeholder for the content
        }
    }
}
