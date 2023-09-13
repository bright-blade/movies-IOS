
import SwiftUI

struct ContentView: View {
    @StateObject var moviesViewModel: MoviesViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(moviesViewModel.movies) { movie in
                        NavigationLink {
                            MovieDetailView(movie: movie,
                                            movieViewModel: moviesViewModel)
                        } label: {
                            MovieTileView(movie: movie)
                                .onAppear{
                                moviesViewModel.loadMore(movie: movie)
                            }
                        }

                        
                    }
                }
            }
            .navigationTitle("Movies (\(moviesViewModel.sortBy.displayValue))")
            .toolbar {
                 ToolbarItem(placement: .navigationBarTrailing) {
                     Menu(content: {
                         Button("Popular") {
                             moviesViewModel.setSortBy(sortBy: .popular)
                         }
                         Button("Up coming") {
                             moviesViewModel.setSortBy(sortBy: .upcoming)
                         }
                         Button("Top Rated") {
                             moviesViewModel.setSortBy(sortBy: .topRated)
                         }
                          
                     }, label: {
                         Text("Sort By")
                     }
                     )
                  }
              }
        }
        .task {
            try? await moviesViewModel.fetchGenres()
            try? await moviesViewModel.fetchMovies()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(moviesViewModel: MoviesViewModel())
    }
}
