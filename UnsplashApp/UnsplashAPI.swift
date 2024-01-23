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
    func unsplashApiBaseUrl() -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos"
        components.queryItems = [
            URLQueryItem(name: "id_client", value: ConfigurationManager.instance.plistDictionnary.clientId),
        ]
        return components
    }
    
    // Par défaut orderBy = "popular" et perPage = 10 -> Lisez la documentation de l'API pour comprendre les paramètres, vous pouvez aussi en ajouter d'autres si vous le souhaitez
    func feedUrl(orderBy: String = "popular", perPage: Int = 10) -> URL? {
        var components = unsplashApiBaseUrl()
        
        components.queryItems?.append(URLQueryItem(name: "order_by", value: orderBy))
        components.queryItems?.append(URLQueryItem(name: "per_page", value: String(perPage)))
        
        return components.url
    }

}
