import Foundation

class FeedState: ObservableObject {
    @Published var homeFeed: [UnsplashPhoto]?
    @Published var topics: [Topics]?

    func fetchHomeFeedPhotos() async {
        guard let url = UnsplashAPI.feedUrlPhotos() else {
            print("Erreur : URL pas valide")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let photos = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
            DispatchQueue.main.async {
                self.homeFeed = photos
            }
        } catch {
            print("Erreur lors du chargement des donées : (error) \(error)")
        }
    }
    
    func fetchHomeFeedTopics() async {
        guard let url = UnsplashAPI.feedUrlTopics() else {
            print("Erreur : URL pas valide")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let photos = try JSONDecoder().decode([Topics].self, from: data)
            DispatchQueue.main.async {
                self.topics = photos
            }
        } catch {
            print("Erreur lors du chargement des donées : (error) \(error)")
        }
    }
    
    func fetchPhotosForTopic(topicSlug: String) async {
        guard let url = UnsplashAPI.feedUrlPhotosForTopic(topicSlug: topicSlug) else {
            print("Erreur : URL pas valide")
            return
        }

        do {
            print(url)
            let (data, _) = try await URLSession.shared.data(from: url)
            let photos = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
            DispatchQueue.main.async {
                self.homeFeed = photos
            }
        } catch {
            print("Erreur lors du chargement des donées : \(error)")
        }
    }
}
