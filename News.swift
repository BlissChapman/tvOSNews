//
//  News.swift
//  tvOSNewsCocoaNuts
//
//  Created by Bliss Chapman on 1/6/16.
//  Copyright © 2016 Bliss Chapman. All rights reserved.
//

import Foundation

struct News {

    // NYTimes Developer API Key
    private let cocoanutsDemoAPIKey = "770e0fabd8b04628936797cf9fa5f5a2"

    enum Section: String {
        case home, world, national, politics, nyregion, business, opinion, technology, science, health, sports, arts, fashion, dining, travel, magazine, realestate
    }

    enum FetchResult {
        case success([String])
        case failure(String)
    }

    func fetchTopStories(forSection section: News.Section, completion callback: @escaping (FetchResult) -> Void) {
        guard let url = URL(string: "http://api.nytimes.com/svc/topstories/v1/\(section).json?api-key=\(cocoanutsDemoAPIKey)") else {
            callback(FetchResult.failure("Could not find news source."))
            return
        }

        //configure request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //configure session
        let session = URLSession(configuration: .default)

        //create the task
        let task = session.dataTask(with: request) { (newsData, response, error) -> Void in

            DispatchQueue.main.async(execute: { () -> Void in

                guard error == nil else {
                    callback(FetchResult.failure(error!.localizedDescription))
                    return
                }

                guard let newsData = newsData else {
                    callback(FetchResult.failure("Failed to retrieve news data."))
                    return
                }

                do {
                    if let newsDictionary = try JSONSerialization.jsonObject(with: newsData, options: .allowFragments) as? NSDictionary {

                        var headlines = [String]()

                        if let results = newsDictionary["results"] as? NSArray {
                            for result in results {
                                if let headline = (result as? NSDictionary)?["abstract"] as? String {
                                    headlines.append(headline)
                                }
                            }
                        }

                        if !headlines.isEmpty {
                            callback(FetchResult.success(headlines))
                        } else {
                            callback(FetchResult.failure("Failed to parse your news headlines."))
                        }

                    } else {
                        callback(FetchResult.failure("Failed to serialize your news data."))
                    }
                } catch let error as NSError {
                    callback(FetchResult.failure(error.localizedDescription))
                }
            })
        }
        
        //send off the network request task
        task.resume()
    }
}
