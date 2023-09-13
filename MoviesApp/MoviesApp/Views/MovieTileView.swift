

import SwiftUI

struct MovieTileView: View {
    let movie: Movie
    
    var body: some View {
        VStack {
            if let posterUrl = MoviesViewModel.imageUrl(path: movie.posterPath) {
                AsyncImage(url: posterUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 200, height: 200)
            }
            
            Text(movie.title)
        }
    }
}

