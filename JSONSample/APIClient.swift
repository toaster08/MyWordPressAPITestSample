//
//  APIClient.swift
//  JSONSample
//
//  Created by toaster on 2021/12/21.
//

import Foundation

enum WordPressError: Error {
    case error
}

final class APIClient {
    static let myWordPress = "https://ytoaster.com//wp-json/wp/v2/posts"
    static let shared = APIClient()
    private init() { }

    var imageLink:[String] = .init()
    func getAPI(url:String,
                completion:(((Result<[WordPressContents],
                                     WordPressError>) -> Void)? )) {

        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            guard let data = data else { return }
            guard let wordpressResponse
                    = try? JSONDecoder().decode([WordPressResposeModel].self,
                                                from: data)  else {
                completion?(.failure(.error))
                return
            }

            self.imageLink = wordpressResponse.compactMap { $0.links }

            var wordPressArticles:[WordPressContents] = .init()
            for (response,imageLink) in zip(wordpressResponse, self.imageLink) {
                wordPressArticles
                    .append(WordPressContents(content: response,
                                              captureImageLink: imageLink))
            }

            completion?(.success(wordPressArticles))
        }
        task.resume()
    }
}

class ImageDownLoader {
    static let shared = ImageDownLoader()
    private init() { }

    var imageData:[Data] = .init()
    func downloadImage(contents: [WordPressContents],
                       completion:((Result<[Data],WordPressError>) -> Void)?) {

        for (i,content) in contents.enumerated() {
            guard let captureImageLink = content.captureImageLink,
                  let url = URL(string: captureImageLink) else {
                return
            }

            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

                guard let data = data else { return }
                guard let wordPressImageResponse
                        = try? JSONDecoder().decode(ImageResponseModel.self, from: data) else {
                    completion?(.failure(WordPressError.error))
                    return
                }

                let imageURL = wordPressImageResponse.mediadetails

                guard let image = URL(string: imageURL) else {
                    fatalError()
                }

                guard let imageData = try? Data(contentsOf: image)  else {
                    fatalError()
                }

                self.imageData.append(imageData)
                if i == (contents.count - 1) {
                    completion?(.success(self.imageData))
                }
            }
            task.resume()
        }
    }
}
