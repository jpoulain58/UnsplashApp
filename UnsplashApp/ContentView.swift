//
//  ContentView.swift
//  UnsplashApp
//
//  Created by Jeremy POULAIN on 1/23/24.
//

import SwiftUI
import Foundation


struct UnsplashPhoto: Codable, Identifiable {
    let id: String
    let slug: String
    let author: User
    let url: UnsplashPhotoUrls
    
    enum CodingKeys: String, CodingKey{
        case id
        case slug
        case author = "user"
        case url = "urls"
    }
}

struct User: Codable {
    let name: String
    let links: ProfileLink?
    let photos: ProfileImage?

    
    enum CodingKeys: String, CodingKey{
        case name = "username"
        case links = "links"
        case photos = "profile_image"
    }
}

struct UnsplashPhotoUrls: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
    
    enum CodingKeys: String, CodingKey{
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

struct ProfileLink: Codable {
    let profile: String?

    enum CodingKeys: String, CodingKey{
        case profile = "html"
    }
}

struct Topics: Codable, Identifiable {
    let id: String
    let slug: String
    let title: String
    let coverPhoto: CoverPhoto
    
    enum CodingKeys: String, CodingKey{
        case id
        case slug
        case title
        case coverPhoto = "cover_photo"
    }
}

struct CoverPhoto: Codable {
    let id: String
    let slug: String
    let url: UnsplashPhotoUrls
    
    enum CodingKeys: String, CodingKey{
        case id
        case slug
        case url = "urls"
    }
}

struct ProfileImage: Codable {
    let medium: String
    
    enum CodingKeys: String, CodingKey{
        case medium
    }
}

struct ContentView: View {
    
    // Déclaration d'une variable d'état, une fois remplie, elle va modifier la vue
    @StateObject var feedState = FeedState()
    
    // Déclaration d'une fonction asynchrone
    func loadData() async {
        await feedState.fetchHomeFeedPhotos()
        await feedState.fetchHomeFeedTopics()
        isLoading = false
        
    }
    
    let columns = [GridItem(.flexible(minimum: 150)), GridItem(.flexible(minimum: 150))]
    
    @State var isLoading = true
    
    var body: some View {
        NavigationStack{
            VStack {
                Button(action: {
                    Task {
                        await loadData()
                        
                    }
                }, label: {
                    Text("Load...")
                })
                ScrollView(.horizontal) {
                    LazyHStack() {
                        if let unwrappedPhotos = feedState.topics  {
                            ForEach(unwrappedPhotos){image in
                                NavigationLink(destination: FeedView(topic: image)) {
                                    VStack{
                                        
                                        AsyncImage(url: URL(string: image.coverPhoto.url.raw)) { image in
                                            image.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 118)
                                        .cornerRadius(12.0)
                                        Text("\(image.title)")
                                            .foregroundStyle(Color(.blue))
                                        
                                    }
                                }
                            }
                            
                        }
                        else {
                            ForEach(0..<12) {_ in
                                VStack{
                                    
                                    Rectangle()
                                        .frame(width: 118)
                                        .cornerRadius(12.0)
                                        .foregroundColor(.gray)
                                    Text("s")
                                        .foregroundStyle(Color(.blue))
                                }
                            }
                        }
                        
                        
                    }
                    .padding()
                    .redacted(reason: isLoading ? .placeholder : .init())
                    
                }
                .frame(height: 120)
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
                                    .frame(height: 150)
                                    .cornerRadius(/*@START_MENU_TOKEN@*/12.0/*@END_MENU_TOKEN@*/)
                                    
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
                .clipShape(RoundedRectangle(cornerSize: /*@START_MENU_TOKEN@*/CGSize(width: 20, height: 10)/*@END_MENU_TOKEN@*/))
                .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
            }
            .navigationBarTitle("Feed")
            
        }
        
    }
}

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
    }
}

#Preview {
    ContentView()
}
