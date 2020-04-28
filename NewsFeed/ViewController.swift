//
//  ViewController.swift
//  NewsFeed
//
//  Created by AAA on 4/28/20.
//  Copyright © 2020 atewari. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (newsFeed?.articles.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.textLabel?.text = newsFeed?.articles[indexPath.row].title
        
        let urlString = newsFeed?.articles[indexPath.row].urlToImage ?? "https://via.placeholder.com/150" //REVISIT
        let imageURL = URL(string: urlString )!
        
        let imageData:NSData = NSData(contentsOf: imageURL)!
        cell.imageView?.image = UIImage(data: imageData as Data)
   
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
                    
                    //REVIST: Investigate the nil imageurl
                    //print(article.title )
                    //print(article.urlToImage!)
                    //print(article.url  )
                    
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
            if error != nil || data == nil {
                print(error!)
                return
            }
            
            do {
                self.newsFeed = try JSONDecoder().decode(NewsFeed.self, from: data!)
                
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Json error")
            }
            
        }.resume()
        
    }
}

