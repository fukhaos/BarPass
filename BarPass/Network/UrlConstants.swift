//
//  UrlConstants.swift
//  guroo
//
//  Created by Bruno Lopes de Mello on 07/05/19.
//  Copyright © 2019 Bruno Lopes de Mello. All rights reserved.
//

import Foundation

enum UrlConstants {
    static let baseUrl = "https://api.themoviedb.org/3/movie"
    static let baseImagesUrl = "https://image.tmdb.org/t/p/w500/"
    static let ApiKey = "3f767426720c364fcf885cdb5d079d5f"
    
    static var apiEndPoint : String {
        get {
            let value = "\(UrlConstants.baseUrl)"
            return value
        }
    }
    
    //Now playing
    static let getNowPlaying = "\(apiEndPoint)/now_playing"
    static let getTopRated = "\(apiEndPoint)/top_rated"
    static let getPopular = "\(apiEndPoint)/popular"
}
