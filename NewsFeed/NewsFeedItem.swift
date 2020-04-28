//
//  NewsFeedItem.swift
//  NewsFeed
//
//  Created by AAA on 4/28/20.
//  Copyright © 2020 atewari. All rights reserved.
//

import Foundation



struct NewsFeed : Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article : Decodable {
    let source: Source
    let author: String?
    let title, articleDescription: String
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String?
}

// MARK: - Source
struct Source : Decodable {
    let id: String?
    let name: String
}

