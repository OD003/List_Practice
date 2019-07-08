//
//  ViewController.swift
//  List
//
//  Created by Daichi on 2019/06/17.
//  Copyright © 2019 Daichi. All rights reserved.
//

import UIKit

struct User: Codable {
var login: String
}

struct GitList {
    
    static func fetchArticle(completion: @escaping([User]) -> Swift.Void) {
        
        let url = "https://api.github.com/users"
        guard var urlComponents = URLComponents(string: url) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in
            
            guard let jsonData = data else {
                return
            }
            do {
                let users = try JSONDecoder().decode([User].self, from: jsonData)
                print(users[0].login)
            } catch {
                print("error")
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

class ViewController: UIViewController {
    
    private var tableView = UITableView()
    fileprivate var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView: do {
            tableView.frame = view.frame
            tableView.dataSource = self
            view.addSubview(tableView)
        }
        
        GitList.fetchArticle(completion: { (users) in
            self.users = users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = users[indexPath.row].login
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
}
