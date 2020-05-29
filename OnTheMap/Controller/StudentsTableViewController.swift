//
//  StudentsTableViewController.swift
//  OnTheMap
//
//  Created by Timi Tejumola on 28/05/2020.
//  Copyright © 2020 Timi Tejumola. All rights reserved.
//


import UIKit

class StudentsTableViewController: UIViewController, LoadDataProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    var students: [StudentLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }
    
     func loadData(){
        showIndicator("Loading...")
        MapClient.getStudenLocations { result in
            self.dismiss(animated: true, completion: nil)
            switch result {
                case .success(let data):
                    self.students = data
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}


extension StudentsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableCell", for: indexPath)
        cell.textLabel?.text = "\(students[indexPath.row].firstName) \(students[indexPath.row].lastName)"
        cell.imageView?.image = UIImage(systemName: "mappin")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: students[indexPath.row].mediaURL) {
            if  UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }else {
                alert(title: "Invalid Url", description: "Cannot open \(students[indexPath.row].mediaURL)", style: .alert, actions: [], viewController: nil)
            }
        }
    }
}
