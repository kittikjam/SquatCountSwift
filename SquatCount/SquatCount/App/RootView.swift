import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            TrainView()
                .tabItem {
                    Label("Train", systemImage: "dumbbell")
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