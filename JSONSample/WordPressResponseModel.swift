//
//  MyAPI.swift
//  JSONSample
//
//  Created by toaster on 2021/12/21.
//

import Foundation

struct WordPressArticles{
    let wordPressContents:WordPressContents
    let wordPressImage:Data
}

struct WordPressContents:Codable {
    let content:WordPressResponseModel?
    let captureImageLink:String?
}

struct WordPressResponseModel:Codable {

    var link:String
    var title:title
    var excerpt:excerpt
    var links:links

    enum CodingKeys:String,CodingKey {
        case link
        case title
        case excerpt
        case links = "_links"
    }
}

struct title:Codable {
    let rendered:String
}

//excerpt:抜粋
struct excerpt:Codable {
    let rendered:String
}

struct links:Codable {
    let featuredmedia:[featuredmedia]

    enum CodingKeys:String,CodingKey {
        case featuredmedia = "wp:featuredmedia"
    }
}

struct featuredmedia:Codable {
//    let href:[href]
    let href:String
}
//
struct href:Codable {
//    let mediadetails:mediadetails
    let mediadetails:[String]

    enum CodingKeys:String,CodingKey {
        case mediadetails = "media_details"
    }
}

//imageのための構造体
struct ImageResponseModel:Codable {
    var mediadetails:mediadetails

    enum CodingKeys:String,CodingKey {
        case mediadetails = "media_details"
    }
}

struct mediadetails:Codable {
    var sizes:sizes
}

struct sizes:Codable {
    var medium:medium
}

struct medium:Codable {
    var sourceurl:String

    enum CodingKeys :String,CodingKey {
        case sourceurl =  "source_url"
    }
}
