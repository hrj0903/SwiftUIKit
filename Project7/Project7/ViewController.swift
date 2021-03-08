//
//  ViewController.swift
//  Project7
//
//  Created by hrj on 2021/03/06.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var savePetitions = [Petition]()
    var filterPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(promptForInfo))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain , target: self, action: #selector(filteredPetitions))
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
            savePetitions = petitions
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func promptForInfo() {
        let ac = UIAlertController(title: "Data Info", message: "The data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    @objc func filteredPetitions() {
        let ac = UIAlertController(title: "Find your petitions", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let findAction = UIAlertAction(title: "Find", style: .default) { _ in
            guard let text = ac.textFields?[0].text else { return }
            self.findPetitions(text)
        }
        
        let backAction = UIAlertAction(title: "Reset All", style: .destructive) { _ in
            self.resetButton()
        }
        
        ac.addAction(findAction)
        ac.addAction(backAction)
        present(ac, animated: true)
    }
    
    func findPetitions(_ text: String) {
        filterPetitions.removeAll()
        for petition in savePetitions {
            if petition.body.lowercased().contains(text.lowercased()) {
                filterPetitions.append(petition)
            }
        }
        
        if filterPetitions.isEmpty { return }
        petitions = filterPetitions
        tableView.reloadData()
        
    }
    
    func resetButton() {
        petitions = savePetitions
        tableView.reloadData()
    }
    
}

