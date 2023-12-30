import SwiftUI

@main
struct ThemeDemoApp: App {
    @State private var selectedTab = 1

    var body: some Scene {
        WindowGroup {
            ContentView(selectedTab: $selectedTab)
                .preferredColorScheme(colorScheme(for: selectedTab))
        }
    }

    private func colorScheme(for tab: Int) -> ColorScheme {
        switch tab {
        case 0:
            return .dark
        case 1:
            return .light
        default:
            return .light
        }
    }
}

struct ContentView: View {
    @Binding var selectedTab: Int

    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Dark Theme")
                .tabItem {
                    Label("Dark", systemImage: "moon.fill")
                }
                .tag(0)

            Text("Light Theme")
                .tabItem {
                    Label("Light", systemImage: "sun.max.fill")
                }
                .tag(1)
        }
        .padding()
    }
}
