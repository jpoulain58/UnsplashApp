// FeedView.swift
import SwiftUI

struct FeedView: View {
    @StateObject var feedState = FeedState()
    @State var isLoading = true
    
    let columns = [GridItem(.flexible(minimum: 150)), GridItem(.flexible(minimum: 150))]
    func loadData() async {
        await feedState.fetchPhotosForTopic(topicSlug: topic.slug)
        isLoading = false
        
    }
    var topic: Topics
    
    var body: some View {
        VStack{
            NavigationStack{
                Button(action: {
                    Task {
                        await loadData()
                    }
                }, label: {
                    Text("Load...")
                })
                ScrollView{
                    LazyVGrid(columns: columns){
                        if let unwrappedPhotos = feedState.homeFeed  {
                            ForEach(unwrappedPhotos){image in
                                NavigationLink(destination: ImageDetailsView(image: image)) {
                                    
                                    AsyncImage(url: URL(string: image.url.regular)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .cornerRadius(12.0)
                                    .frame(height: 150)
                                }
                            }
                        }
                        else {
                            ForEach(0..<12) {_ in
                                Rectangle()
                                    .frame(height: 150)
                                    .cornerRadius(12.0)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .redacted(reason: isLoading ? .placeholder : .init())
                }
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                .padding(.horizontal)
                .navigationBarTitle("\(topic.title)") 
            }
        }
    }
}

// Example usage
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleUrls = UnsplashPhotoUrls(
            raw: "https://example.com/raw.jpg",
            full: "https://example.com/full.jpg",
            regular: "https://example.com/regular.jpg",
            small: "https://example.com/small.jpg",
            thumb: "https://example.com/thumb.jpg"
        )

        let exampleCoverPhoto = CoverPhoto(
            id: "exampleId",
            slug: "exampleSlug",
            url: exampleUrls
        )

        let exampleTopic = Topics(
            id: "exampleTopicId",
            slug: "exampleTopicSlug",
            title: "Example Topic Title",
            coverPhoto: exampleCoverPhoto
        )

        FeedView(topic: exampleTopic) // Pass the example topic here
    }
}
