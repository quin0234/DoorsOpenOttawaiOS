//
//  ViewController.swift
//  opendoorsottawa
//
//  Created by Paul Quinnell on 2017-11-30.
//  Copyright © 2017 Paul Quinnell. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var Buildings = [Building]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadJSON {
            self.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Buildings.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell") as? BuildingTableViewCell else { return UITableViewCell() }
        cell.buildingTitle.layer.cornerRadius = 5
        cell.buildingTitle.clipsToBounds = true
        cell.buildingTitle.numberOfLines = 0
        cell.buildingTitle.lineBreakMode = .byWordWrapping
        cell.buildingTitle.font = UIFont.systemFont(ofSize: 14.0)
        cell.buildingTitle.text = Buildings[indexPath.row].nameEN
        let imgLink = Buildings[indexPath.row].image
        
        let urlString = "https://doors-open-ottawa.mybluemix.net/"+imgLink.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        

        if let imageURL = URL(string: urlString) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.buildingImg.image = image
                        cell.buildingImg.layer.cornerRadius = 21
                        cell.buildingImg.clipsToBounds = true
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BuildingViewController {
            destination.blding = Buildings[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    func downloadJSON(completed: @escaping () -> ()) {
        
        let url = URL(string: "https://doors-open-ottawa.mybluemix.net/buildings")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil {
                do {
                    self.Buildings = try JSONDecoder().decode([Building].self, from: data!)
                    
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch {
                    print("JSON Error")
                    print(error)
                }
            }
        }.resume()
    }
}

