//
//  ViewController.swift
//  Project3
//
//  Created by hrj on 2021/02/12.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        pictures.sort()
        print(pictures)
    }
    // n번째 섹션에 몇 개의 row가 존재하는지를 반환합니다.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    // n번째 섹션의 m번재 row를 그리는데 필요한 셀을 반환합니다.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            //2: success! Set its selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedPicturePosition = indexPath.row + 1
            vc.totalNumberOfImages = pictures.count
            //3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


