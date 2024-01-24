//
//  ImageDetails.swift
//  UnsplashApp
//
//  Created by Jeremy POULAIN on 1/24/24.
//

import SwiftUI

struct ImageDetailsView: View {
    var image: UnsplashPhoto

    private let options = ["Regular", "Full", "Small"]

    @State private var selectedOption = "Regular"

    var body: some View {
        VStack {
            Link(destination: URL(string: image.author.links?.profile ?? "")!){
                if let unwrappedProfileImage = image.author.photos?.medium{
                    AsyncImage(url: URL(string: unwrappedProfileImage)).cornerRadius(12.0)
                }
                Text("@\(image.author.name)")
            }
            Picker("Options", selection: $selectedOption) {
                ForEach(options, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            Spacer()
            if let imageUrl = URL(string: selectedImageUrl()) {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFit()
                    case .failure(_):
                        Text("Unable to load image")
                    case .empty:
                        ProgressView()
                    @unknown default:
                        ProgressView()
                    }
                }
            }
            Spacer()
        }
    }

    func selectedImageUrl() -> String {
        switch selectedOption {
        case "Full":
            return image.url.full
        case "Small":
            return image.url.small
        default: // "Regular"
            return image.url.regular
        }
    }
}
#Preview {
    
    ImageDetailsView(image: UnsplashPhoto(
        id: "w-yuRFSkbVw",
        slug: "a-man-in-a-red-shirt-is-looking-at-the-desert-w-yuRFSkbVw",
        author: User(name: "NEOM",
                     links: ProfileLink(profile:"https://api.unsplash.com/users/neom"),
                                        photos: ProfileImage(medium: "https://images.unsplash.com/profile-1679489218992-ebe823c797dfimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=64&h=64")),
        url: UnsplashPhotoUrls(
            raw: "https://images.unsplash.com/photo-1682685796014-2f342188a635",
            full: "https://images.unsplash.com/photo-1682685796014-2f342188a635?crop=entropy&cs=srgb",
            regular: "https://images.unsplash.com/photo-1682685796014-2f342188a635?crop=entropy&cs=tinysrgb&fit=max",
            small: "https://images.unsplash.com/photo-1682685796014-2f342188a635?crop=entropy&cs=tinysrgb&fit=max&w=400",
            thumb: "https://images.unsplash.com/photo-1682685796014-2f342188a635?crop=entropy&cs=tinysrgb&fit=max&w=200"
        )
    ))}
