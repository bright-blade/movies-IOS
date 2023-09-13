

import SwiftUI

@main
struct MoviesAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(moviesViewModel: MoviesViewModel())
                .accentColor(.red)
        }
    }
}
