import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Train", systemImage: "weightlifter")
                }

            ContentView()
                .tabItem {
                    Label("Progress", systemImage: "gear")
                }

            ContentView()
                .tabItem {
                    Label("Profile", systemImage: "person")
        }
    }
}
}