//
//  ViewController.swift
//  MilestoneProjects4-6
//
//  Created by hrj on 2021/03/05.
//

import UIKit

class ViewController: UITableViewController {
    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        navigationItem.rightBarButtonItems = [share, add]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(reset))
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Enter Shopping Item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] action in
            guard let writtenItem = ac?.textFields?[0].text else { return }
            self?.add(writtenItem)
        }
        
        ac.addAction(addAction)
        present(ac, animated: true)
    }
    
    @objc func shareTapped() {
        let text = "List"
        let list = shoppingList.joined(separator: "\n")
        let vc = UIActivityViewController(activityItems: [text, list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    @objc func reset() {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    func add(_ writtenItem: String) {
        let lowerWrittenItem = writtenItem.lowercased()
        
        shoppingList.insert(lowerWrittenItem, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        return
    }
}

