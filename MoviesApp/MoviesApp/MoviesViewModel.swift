

import Foundation

@MainActor
class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    var genres: [Genre] = []
    @Published var providers: [ProviderModel] = []
    @Published var reviews: [MovieReview] = []
    @Published var trailer: TrailerModel?

    var page = 0
    
    var sortBy: MoviesSortBy = .popular
    
    let httpHeaders = [
        "accept": "application/json",
        "Authorization": "***Enter your Token***"
      ]
    
    enum MoviesSortBy: String {
        case popular
        case upcoming
        case topRated = "top_rated"
        
        var displayValue: String {
            switch self {
            case .popular:
                return "Popular"
            case .upcoming:
                return "Up coming"
            case .topRated:
                return "Top rated"
            }
        }
    }
    
    func reset() {
        page = 0
        movies = []
    }
    
    func setSortBy(sortBy: MoviesSortBy) {
        reset()
        self.sortBy = sortBy
        Task {
            try? await fetchMovies()
        }
    }
    
    static func imageUrl(path: String) -> URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    static func youtubeUrl(path: String) -> URL? {
        return URL(string: "https://www.youtube.com/embed/\(path)")
    }
    
    func gerneForId(id: Int) -> String? {
        for gerne in genres {
            if gerne.id == id {
                return gerne.name
            }
        }
        return nil
    }
    
    enum MovieApiEndpoints {
        case genres
        case movies(sortBy: MoviesSortBy, nextPage: Int)
        case trailers(movieId: Int)
        case reviews(movieId: Int)
        case providers(movieId: Int)
        
        var url: String {
            switch self {
            case .providers(let movieId):
                return "movie/\(movieId)/watch/providers"
            case .genres:
                return "genre/movie/list"
            case .movies(let sortBy, let nextPage):
                return "movie/\(sortBy.rawValue)?page=\(nextPage)"
            case .trailers(let movieId):
                return "movie/\(movieId)/videos"
            case .reviews(let movieId):
                return "movie/\(movieId)/reviews"
            }
        }
    }
    
    func fetchMovieApi(endpoint: MovieApiEndpoints) async throws -> Data? {
        let url = URL(string: "https://api.themoviedb.org/3/\(endpoint.url)")!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = httpHeaders
         
        let (data, response) = try await URLSession.shared.data(for: request)
        if (response as? HTTPURLResponse)?.statusCode == 200 {
            return data
        }
        
        return nil
    }
    
    
    func fetchGenres() async throws {
        guard let data = try await fetchMovieApi(endpoint: .genres) else { return }
        let genreResponse = try JSONDecoder().decode(GenresResponse.self, from: data)
        genres = genreResponse.genres
    }
    
    func fetchProviders(movieId: Int) async throws {
        self.providers = []
        guard let data = try await fetchMovieApi(endpoint: .providers(movieId: movieId)) else { return }
        let providerResponse = try JSONDecoder().decode(MovieProvidersResponse.self, from: data)
        self.providers = providerResponse.results.il?.flatrate ?? []
    }
    
    func fetchReviews(movieId: Int) async throws {
        self.reviews = []
        guard let data = try await fetchMovieApi(endpoint: .reviews(movieId: movieId)) else { return }
        let reviewsResponse = try JSONDecoder().decode(MovieReviewResults.self, from: data)
        self.reviews = reviewsResponse.results
    }
    
    func fetchTrailer(movieId: Int) async throws {
        self.trailer = nil
        guard let data = try await fetchMovieApi(endpoint: .trailers(movieId: movieId)) else { return }
        let trailerResponse = try JSONDecoder().decode(TrailerResponse.self, from: data)
        self.trailer = trailerResponse.results.first(where: { video in
            video.type == "Trailer" && video.site == "YouTube" && video.official == true
        })
    }
    
    func fetchMovies() async throws {
        let nextPage = page + 1
        
        guard let data = try await fetchMovieApi(endpoint: .movies(sortBy: self.sortBy, nextPage: nextPage)) else { return }
        let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
        if page + 1 == nextPage {
            page += 1
            movies += movieResponse.results
        }
    }

    
    func loadMore(movie: Movie) {
        if movies.last?.id == movie.id {
            Task {
                try? await fetchMovies()
            }
        }
    }
}
