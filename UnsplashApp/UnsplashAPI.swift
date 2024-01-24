//
//  UnsplashAPI.swift
//  UnsplashApp
//
//  Created by Jeremy POULAIN on 1/23/24.
//

import Foundation

struct UnsplashAPI{

    // Construit un objet URLComponents avec la base de l'API Unsplash
    // Et un query item "client_id" avec la clé d'API retrouvé depuis PListManager
    static func unsplashApiBaseUrl(basePath: String) -> URLComponents {
        var components = URLComponents()
        if (basePath == "/photos"){
            components.path = "/photos"
        }
        else if (basePath == "/topics") {
            components.path = "/topics"
        }
        else {
            components.path = basePath
        }
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: ConfigurationManager.instance.plistDictionnary.clientId),
        ]
        return components
    }
    
    // Par défaut orderBy = "popular" et perPage = 10 -> Lisez la documentation de l'API pour comprendre les paramètres, vous pouvez aussi en ajouter d'autres si vous le souhaitez
    static func feedUrlPhotos(orderBy: String = "popular", perPage: Int = 10) -> URL? {
        var components = unsplashApiBaseUrl(basePath: "/photos")
        
        components.queryItems?.append(URLQueryItem(name: "order_by", value: orderBy))
        components.queryItems?.append(URLQueryItem(name: "per_page", value: String(perPage)))
        
        return components.url
    }

    static func feedUrlTopics(orderBy: String = "popular", perPage: Int = 10) -> URL? {
        var components = unsplashApiBaseUrl(basePath: "/topics")
        
        components.queryItems?.append(URLQueryItem(name: "order_by", value: orderBy))
        components.queryItems?.append(URLQueryItem(name: "per_page", value: String(perPage)))
        
        return components.url
    }
    
    
    static func feedUrlPhotosForTopic(topicSlug: String, perPage: Int = 10) -> URL? {
        var components = unsplashApiBaseUrl(basePath: "/topics/\(topicSlug)/photos")
        
        components.queryItems?.append(URLQueryItem(name: "per_page", value: String(perPage)))
        
        return components.url
    }

}
