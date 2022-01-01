//
//  ViewController.swift
//  JSONSample
//
//  Created by toaster on 2021/12/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var excerptTextView: UITextView!
    
    var apiClient:APIClient?
    var imageDownloader:ImageDownLoader?
    private var contents: [WordPressContents] = []
    private var imageData:[Data] = []
    private var articles: [WordPressArticles] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        apiClient = APIClient.shared
        apiClient?.getAPI(url: APIClient.myWordPress,
                          completion: { result in
                            DispatchQueue.main.async { [self] in

                                switch result {
                                case .failure(let error):
                                    print(error)
                                case .success(let contents):
                                    self.contents = contents
                                    //                                    print("contents:\(contents)")
                                    getImage()
                                }
                            }
                          })
    }

    func getImage() {
        imageDownloader = ImageDownLoader.shared
        imageDownloader?
            .downloadImage(contents: contents ,
                           completion: { result in
                            DispatchQueue.main.async { [self] in
                                switch result {
                                case .failure(let error):
                                    print("ここでエラー") 
                                    print(error)
                                case .success(let imageData):
                                    self.imageData = imageData
                                    //                                    print("imageData：\(imageData)")
                                    makeArticle()
                                }
                            }
                           })
    }

    func makeArticle() {
        for (contents,imageData) in zip(self.contents, self.imageData) {
            articles
                .append(WordPressArticles(wordPressContents: contents,
                                          wordPressImage: imageData))
        }

        print("articles count:\(articles.count)")
        for article in articles {
            print("article.wordPressContents:\(article.wordPressContents)")
            print("article.wordPressImage:\(article.wordPressImage)")
        }
        
        configure()
    }

    func configure(){
        self.articles.forEach {

            titleLabel.text
                = $0.wordPressContents
                .content?
                .title

            excerptTextView.text
                = $0.wordPressContents
                .content?
                .excerpt
                .replacingOccurrences(of: "<.+?>|&.+?;",
                                      with: "",
                                      options: .regularExpression,
                                      range: nil)

            imageView.image = UIImage(data: $0.wordPressImage)

//            titleLabel.text
//                = $0.wordPressContents
//                .content?
//                .title
//                .rendered

//            excerptTextView.text
//                = $0.wordPressContents
//                .content?
//                .excerpt
//                .rendered
//                .replacingOccurrences(of: "<.+?>|&.+?;",
//                                      with: "",
//                                      options: .regularExpression,
//                                      range: nil)
        }
    }
}

