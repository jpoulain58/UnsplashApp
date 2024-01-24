import Combine
import Foundation

class FeedState: ObservableObject {
    @Published var homeFeed: [UnsplashPhoto]?
    @Published var topics: [Topics]?

    private var cancellables = Set<AnyCancellable>()

    func fetchHomeFeedPhotos() {
        guard let url = UnsplashAPI.feedUrlPhotos() else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [UnsplashPhoto].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .map { Optional($0) }
            .assign(to: \.homeFeed, on: self)
            .store(in: &cancellables)
    }
    
    func fetchHomeFeedTopics() {
        guard let url = UnsplashAPI.feedUrlTopics() else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Topics].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .map { Optional($0) }
            .assign(to: \.topics, on: self)
            .store(in: &cancellables)
    }
    
    func fetchPhotosForTopic(topicSlug: String) {
        guard let url = UnsplashAPI.feedUrlPhotosForTopic(topicSlug: topicSlug) else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [UnsplashPhoto].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .map { Optional($0) }
            .assign(to: \.homeFeed, on: self)
            .store(in: &cancellables)
    }
}
