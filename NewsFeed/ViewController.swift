//
//  ViewController.swift
//  NewsFeed
//
//  Created by AAA on 4/28/20.
//  Copyright © 2020 atewari. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadImageFrom( link:String, contentMode: UIView.ContentMode) {
        URLSession.shared.dataTask( with: URL(string:link)!, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
            
            
        }).resume()
    }
}


class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (newsFeed?.articles.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        
        cell.textLabel?.text = newsFeed?.articles[indexPath.row].title
        
        let urlString = newsFeed?.articles[indexPath.row].urlToImage
        if let imageURL = URL(string: urlString! ) {
            if let imageData:NSData = NSData(contentsOf: imageURL) {
                   cell.imageView?.image = UIImage(data: imageData as Data)
            }
        }
       
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUrl = URL(string: (newsFeed?.articles[indexPath.row].url)!)
        UIApplication.shared.open(selectedUrl!, options: [:], completionHandler: nil)
    }
    
    @IBOutlet weak var newsFeedTable: UITableView!
    
    //var newsFeed:NewsFeed = NewsFeed(status: "test", totalResults: 0, articles: [])
    var newsFeed:NewsFeed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        newsFeedTable.delegate = self
        newsFeedTable.dataSource = self
        
        downloadFeed() {
            print("Success \(self.newsFeed?.articles.count ?? 0 )")
            
            if let listArticles = self.newsFeed?.articles {
                for article in listArticles {
                    
                    if (article.urlToImage == nil) {
                        print("Found a nil image ")
                        dump(article)
                    }
                }
            }
            
            self.newsFeedTable.reloadData()
        }
    }
    
    
    func downloadFeed(completion: @escaping () -> () ) {
        let url = URL(string:"https://newsapi.org/v2/top-headlines?country=us&apiKey=1437be957ba74f9e93cf1688a28a05ac")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data, error == nil else {
                print("URL Data Fetch Error : ")
                print(error)
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is (httpStatus.statusCode)")
                print("response = \(response)")
            }
            if let body_response = String(data: data, encoding: String.Encoding.utf8) {
                print(body_response)
                do {
                    self.newsFeed = try JSONDecoder().decode(NewsFeed.self, from: data)
                    dump(self.newsFeed)
                    DispatchQueue.main.async {
                        completion()
                    }
                } catch {
                    print(error)
                }
            }
            
        }.resume()
        
    }
}

