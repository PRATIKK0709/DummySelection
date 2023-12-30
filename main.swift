import SwiftUI

@main
struct ThemeDemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            ContentView(selectedTab: $themeManager.selectedTab)
                .preferredColorScheme(themeManager.colorScheme)
                .environmentObject(themeManager)
        }
    }
}

class ThemeManager: ObservableObject {
    @AppStorage("selectedTab") var selectedTab: Int = 2 {
        didSet {
            updateColorScheme()
        }
    }

    @Published var colorScheme: ColorScheme = .light

    init() {
        updateColorScheme()
    }

    private func updateColorScheme() {
        switch selectedTab {
        case 0:
            colorScheme = .dark
        case 1:
            colorScheme = .light
        case 2:
            colorScheme = .light // Default theme
        case 3:
            colorScheme = smartTheme()
        default:
            break
        }
    }

    private func smartTheme() -> ColorScheme {
        let hour = Calendar.current.component(.hour, from: Date())
        let isDaytime = (6..<18).contains(hour)

        return isDaytime ? .light : .dark
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Your setup code here
        return true
    }
}

struct ContentView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject private var themeManager: ThemeManager

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

            Text("Default Theme")
                .tabItem {
                    Label("Default", systemImage: "star.fill")
                }
                .tag(2)

            VStack {
                Text("Smart Theme")
                    .font(.title)

                Text("Current Time: \(formattedCurrentTime())")
                    .font(.headline)

                Text("Mode: \(smartThemeExplanation())")
                    .font(.headline)
            }
            .tabItem {
                Label("Smart", systemImage: "gearshape.fill")
            }
            .tag(3)
        }
        .padding()
        .onChange(of: selectedTab) { newTab in
            themeManager.selectedTab = newTab
        }
    }

    private func formattedCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }

    private func smartThemeExplanation() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let isDaytime = (6..<18).contains(hour)

        return isDaytime ? "Light Mode" : "Dark Mode"
    }
}
