import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            TrainView()
                .tabItem {
                    Label("Train", systemImage: "dumbbell")
                }

            ProgressView()
                .tabItem {
                    Label("Progress", systemImage: "gear")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
        }
    }
}
}