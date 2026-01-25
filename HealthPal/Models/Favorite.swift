//
//  Favorite.swift
//  HealthPal
//
//  Created by LILIANA on 1/24/26.
//
import Foundation

struct FavoritesResponse: Decodable {
    let doctors: [FavoriteItem]
    let hospitals: [FavoriteItem]
}

struct FavoriteItem: Decodable {
    let id: Int
}
