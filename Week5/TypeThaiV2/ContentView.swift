import SwiftUI
import Playgrounds

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.homeBackground
                    .ignoresSafeArea()
                
                VStack {
                    NavigationLink {
                        PracticeView()
                    } label: {
                        Text("Practice Flashcards")
                    }
                    .buttonStyle(ChunkyButtonStyle())
                    
                    NavigationLink {
                        ReviewView()
                    } label: {
                        Text("Test Flashcards")
                    }
                    .buttonStyle(ChunkyButtonStyle())
                    
                    NavigationLink {
                        ReviewView()
                    } label: {
                        Text("View All Words")
                    }
                    .buttonStyle(ChunkyButtonStyle())
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

#Preview {
    ContentView()
}
