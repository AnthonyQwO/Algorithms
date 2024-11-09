import SwiftUI

var sz: Int = 30

struct ContentView: View {

    var body: some View {
        TabView {
            NavigationView {
                MainPageView()
                    .navigationTitle("Algorithms")
            }
            .tabItem {
                VStack {
                    Image(systemName: "mail.stack")
                    Text("Main")
                }
            }
            
            NavigationView {
                SettingPage()
                    .navigationTitle("Setting")
            }
            .tabItem {
                Image(systemName: "gearshape")
                Text("Setting")
            }
        
        }
    }
}
