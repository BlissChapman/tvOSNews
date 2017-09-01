//
//  ViewController.swift
//  tvOSNewsCocoaNuts
//
//  Created by Bliss Chapman on 1/6/16.
//  Copyright © 2016 Bliss Chapman. All rights reserved.
//

import UIKit
import AVFoundation

final class ViewController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!

    fileprivate var headlines = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let news = News()
        news.fetchTopStories(forSection: News.Section.world) { (fetchResult) -> Void in
            switch fetchResult {
            case .success(let headlines):
                self.headlines = headlines
                self.tableView.reloadData()
            case .failure(let description):
                let errorAlert = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlines.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCellReuseID") else {
            // time to freak out
            return UITableViewCell()
        }

        cell.textLabel?.text = headlines[indexPath.row]

        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: headlines[indexPath.row])
        synthesizer.speak(utterance)
    }
}
