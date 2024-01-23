import UIKit


struct Movie: Codable {
    let title: String
    let releaseYear: Int
    let genre: String
    let director: String?
}
let jsonString = """
[
    {
        "title": "Inception",
        "releaseYear": 2010,
        "genre": "Sci-Fi"
    },
    {
        "title": "The Dark Knight",
        "releaseYear": 2008,
        "genre": "Action",
        "director": "Christopher Nolan"
    }
]
"""
if let jsonData = jsonString.data(using: .utf8) {
    do {
        let movies = try JSONDecoder().decode([Movie].self, from: jsonData)
        // Ici, vous avez un tableau de films que vous pouvez utiliser.
        for movie in movies {
            print("Film: \(movie.title), Année de sortie: \(movie.releaseYear), Genre: \(movie.genre), Director: \(movie.director ?? "aucun")")
        }
    } catch {
        print("Erreur de décodage: \(error)")
    }
}
