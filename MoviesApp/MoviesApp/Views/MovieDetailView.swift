

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @ObservedObject var movieViewModel: MoviesViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                HStack {
                    MovieTileView(movie: movie)
                        .font(.largeTitle)
                        .bold()
                    VStack {
                        HStack {
                            Image(systemName: "star.fill")
                            Text(String(movie.voteAverage)).font(.largeTitle).bold()
                        }
                        VStack(alignment: .leading) {
                            Text("Release Date:")
                            Text(movie.releaseDate).font(.callout).bold()
                        }
                        
                        ForEach(movie.genreIds, id: \.self) { genreId in
                            if let gerneName = movieViewModel.gerneForId(id: genreId) {
                                Text(gerneName)
                            }
                        }
                        
                        if let trailer = movieViewModel.trailer,
                        let trailerUrl = MoviesViewModel.youtubeUrl(path: trailer.key) {
                            NavigationLink("Trailer") {
                                WebView(url: trailerUrl)
                            }
                        }
                    }
                    Spacer()
                }
                
                if movieViewModel.providers.isEmpty == false {
                    VStack(alignment: .leading) {
                        Text("Providers").bold()
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(movieViewModel.providers) { provider in
                                    if let providerLogoUrl = MoviesViewModel.imageUrl(path: provider.logo){
                                        AsyncImage(url: providerLogoUrl) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 50, height: 50)
                                    }
                                }
                            }
                        }
                        
                    }
                }
                
                
                VStack(alignment: .leading) {
                    Text("Description").bold()
                    Text(movie.overview)
                }
                
                
                if movieViewModel.reviews.isEmpty == false {
                    
                    Divider()
                    VStack(alignment: .leading) {
                        Text("Reviews").bold()
                        
                        ForEach(movieViewModel.reviews) { review in
                            Text(review.content).lineLimit(5)
                            HStack {
                                Spacer()
                                Text(review.author).foregroundColor(.accentColor)
                            }
                            Divider()
                            
                        }
                        
                    }
                    
                }
                
                
                Spacer()
                
            }.padding()
        }
            .task {
                try? await movieViewModel.fetchProviders(movieId: movie.id)
                try? await movieViewModel.fetchReviews(movieId: movie.id)
                try? await movieViewModel.fetchTrailer(movieId: movie.id)
            }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: Movie(id: 1,
                                     genreIds: [28, 12],
                                     title: "Barbie",
                                     overview: "Barbie and Ken are having the time of their lives in the colorful and seemingly perfect world of Barbie Land. However, when they get a chance to go to the real world, they soon discover the joys and perils of living among humans.",
                                     voteAverage: 8.5,
                                     releaseDate: "12/12/2017",
                                     posterPath: "/iuFNMS8U5cb6xfzi51Dbkovj7vM.jpg"),
                        movieViewModel: MoviesViewModel())
    }
}


