//
//  ViewController.swift
//  tvOSNewsCocoaNuts
//
//  Created by Bliss Chapman on 1/6/16.
//  Copyright © 2016 Bliss Chapman. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var headlines = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let news = News()
        news.fetchTopStories(forSection: News.Section.world) { (fetchResult) -> Void in
            switch fetchResult {
            case .Success(let headlines):
                self.headlines = headlines
                self.tableView.reloadData()
            case .Failure(let description):
                let errorAlert = UIAlertController(title: "Error", message: description, preferredStyle: .Alert)
                self.presentViewController(errorAlert, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlines.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("newsCellReuseID")
        
        cell!.textLabel?.text = headlines[indexPath.row]
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: headlines[indexPath.row])
        synthesizer.speakUtterance(utterance)
    }
}

extension ViewController: UITableViewDelegate {
    
}

