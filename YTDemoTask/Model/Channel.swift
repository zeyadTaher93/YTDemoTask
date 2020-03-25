//
//  Channel.swift
//  YTDemoTask
//
//  Created by zeyad on 3/24/20.
//  Copyright © 2020 zeyad. All rights reserved.
//

import Foundation

    // MARK: 
    struct Channel: Codable {
        
        let items: [Item]
    }

    // MARK: - Item
    struct Item: Codable {
        let kind:String?
        let etag, id: String
        let snippet: Snippet
        let contentDetails: ContentDetails
    }

    // MARK: - ContentDetails
    struct ContentDetails: Codable {
        let relatedPlaylists: RelatedPlaylists
    }

    // MARK: - RelatedPlaylists
    struct RelatedPlaylists: Codable {
        let uploads, watchHistory, watchLater: String
    }

    // MARK: - Snippet
    struct Snippet: Codable {
        let title, snippetDescription, publishedAt: String
        let thumbnails: Thumbnails
        let localized: Localized
        let country: String?

        enum CodingKeys: String, CodingKey {
            case title
            case snippetDescription = "description"
            case publishedAt, thumbnails, localized, country
        }
    }

    // MARK: - Localized
    struct Localized: Codable {
        let title, localizedDescription: String

        enum CodingKeys: String, CodingKey {
            case title
            case localizedDescription = "description"
        }
    }

    // MARK: - Thumbnails
    struct Thumbnails: Codable {
        let thumbnailsDefault, medium, high: Default

        enum CodingKeys: String, CodingKey {
            case thumbnailsDefault = "default"
            case medium, high
        }
    }

    // MARK: - Default
    struct Default: Codable {
        let url: String
        let width, height: Int
    }

    // MARK: - PageInfo
    struct PageInfo: Codable {
        let totalResults, resultsPerPage: Int
    }

