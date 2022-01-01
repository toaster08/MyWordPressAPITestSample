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

struct WordPressContents:Decodable {
    let content:WordPressResposeModel?
    let captureImageLink:String?
}

struct WordPressResposeModel {

    var title:String
    var excerpt:String
    var links:String

    enum CodingKeys:String,CodingKey {
        case title
        case excerpt
        case links = "_links"
    }

    enum CustomCodingKeys:String,CodingKey {
        case rendered
        case featuredmedia = "wp:featuredmedia"
        case href
    }
}

extension WordPressResposeModel:Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let excerpt
            = try container
            .nestedContainer(keyedBy: CustomCodingKeys.self, forKey: .excerpt)
            .decode(String.self, forKey: .rendered)

        let title
            = try container
            .nestedContainer(keyedBy: CustomCodingKeys.self, forKey: .title)
            .decode(String.self,forKey: .rendered)

        var linkNestedContainer
            = try container
            .nestedContainer(keyedBy: CustomCodingKeys.self, forKey: .links)
            .nestedUnkeyedContainer(forKey: .featuredmedia)

        var link = String()
        while !linkNestedContainer.isAtEnd {
            link = try linkNestedContainer
                .nestedContainer(keyedBy: CustomCodingKeys.self)
                .decode(String.self, forKey: .href)
        }

        self.init(title:title, excerpt: excerpt, links: link)
    }
}
//imageのための構造体
struct ImageResponseModel {
    var mediadetails:String

    enum CodingKeys:String,CodingKey {
        case mediadetails = "media_details"
    }

    enum CustomCodingKeys:String,CodingKey {
        case sizes
        case medium
        case sourceurl = "source_url"
    }
}

extension ImageResponseModel:Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let source
            = try container
            .nestedContainer(keyedBy: CustomCodingKeys.self,
                             forKey: .mediadetails)
            .nestedContainer(keyedBy: CustomCodingKeys.self,
                             forKey: .sizes)
            .nestedContainer(keyedBy: CustomCodingKeys.self,
                             forKey: .medium)
            .decode(String.self,forKey: .sourceurl)

        self.init(mediadetails: source)

//        let sizesContainer
//            = try mediadetailsContainer
//            .nestedContainer(keyedBy: CustomCodingKeys.self,
//                             forKey: .sizes)
//        let mediumContainer
//            = try sizesContainer
//            .nestedContainer(keyedBy: CustomCodingKeys.self,
//                             forKey: .medium)

//        let source = try mediadetailsContainer.decode(String.self,
//                                               forKey: .sourceurl)

        self.init(mediadetails: source)
    }
}

//リファクタリング前のカスタムデコード
//struct WordPressResponseModel:Codable {
//
//    var link:String
//    var title:title
//    var excerpt:excerpt
//    var links:links
//
//    enum CodingKeys:String,CodingKey {
//        case link
//        case title
//        case excerpt
//        case links = "_links"
//    }
//}
//
//struct title:Codable {
//    let rendered:String
//}
//
////excerpt:抜粋
//struct excerpt:Codable {
//    let rendered:String
//}
//
//struct links:Codable {
//    let featuredmedia:[featuredmedia]
//
//    enum CodingKeys:String,CodingKey {
//        case featuredmedia = "wp:featuredmedia"
//    }
//}
//
//struct featuredmedia:Codable {
////    let href:[href]
//    let href:String
//}
////
//struct href:Codable {
////    let mediadetails:mediadetails
//    let mediadetails:[String]
//
//    enum CodingKeys:String,CodingKey {
//        case mediadetails = "media_details"
//    }
//}
//
//リファクタリング前のカスタムデコード
//struct ImageResponseModel:Codable {
//    var mediadetails:mediadetails
//
//    enum CodingKeys:String,CodingKey {
//        case mediadetails = "media_details"
//    }
//}
//
//struct mediadetails:Codable {
//    var sizes:sizes
//}
//
//struct sizes:Codable {
//    var medium:medium
//}
//
//struct medium:Codable {
//    var sourceurl:String
//
//    enum CodingKeys :String,CodingKey {
//        case sourceurl =  "source_url"
//    }
//}
