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
    
    enum CodingKeys: String, CodingKey{
        case name
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


struct ContentView: View {
    
    // Déclaration d'une variable d'état, une fois remplie, elle va modifier la vue
    @State var imageList: [UnsplashPhoto] = []
    @StateObject var feedState = FeedState()

    // Déclaration d'une fonction asynchrone
    func loadData() async {

        do {
            feedState.loadData()

        } catch {
            print("Error: \(error)")
        }
    }
    
    let columns = [GridItem(.flexible(minimum: 150)), GridItem(.flexible(minimum: 150))]
    

    
    var body: some View {
        VStack {
            NavigationStack{
                Button(action: {
                                Task {
                                    await loadData()
                                }
                            }, label: {
                                Text("Load Data")
                            })
                ScrollView{
                    LazyVGrid(columns: columns){
                        ForEach(imageList){image in
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
                .clipShape(RoundedRectangle(cornerSize: /*@START_MENU_TOKEN@*/CGSize(width: 20, height: 10)/*@END_MENU_TOKEN@*/))
                .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                .navigationBarTitle("Feed")
            }
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
