//
//  ViewController.swift
//  MilestoneProjects1-3
//
//  Created by hrj on 2021/02/19.
//

import UIKit

class ViewController: UITableViewController {
    var flags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Flag Collection"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix("3x.png") {
                flags.append(item)
            }
        }
    
        flags.sort()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        cell.textLabel?.text = flags[indexPath.row].uppercased().replacingOccurrences(of: "@3X.PNG", with: "")
        cell.imageView?.image = UIImage(named: flags[indexPath.row])
        cell.imageView?.layer.borderWidth = 1
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedFlag = flags[indexPath.row]
            vc.title = "\(flags[indexPath.row].uppercased().replacingOccurrences(of: "@3X.PNG", with: " "))"
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}

