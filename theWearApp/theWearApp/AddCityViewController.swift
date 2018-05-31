//
//  AddCityViewController.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 30.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suitableCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = suitableCities[indexPath.row]
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        cities?.append(self.suitableCities[indexPath.row])
        NotificationCenter.default.post(name: Notification.Name(rawValue: "upF"), object: nil)
    }
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter the city"
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.borderStyle = UITextBorderStyle.none
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.backgroundColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let suitableCititesTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 30
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
 
    @objc func textFieldDidChange(_ textField: UITextField) {
        pendingRequestWorkItem?.cancel()
        
        let requestWorkitem = DispatchWorkItem {[weak self] in
            self?.suitableCities = [String]()
            self?.suitableCititesTableView.reloadData()
            self?.SuitableCitiesRequest(inputText: textField.text!)
        }
        
        pendingRequestWorkItem = requestWorkitem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: requestWorkitem)
    }
    
    var suitableCities = [String]()
    
    func SuitableCitiesRequest(inputText: String) {
        let input = inputText.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(input)&types=(cities)&language=en&key=AIzaSyDCBBOmhf9mpqKW0T-2d3zaCdB-LpJmKTc")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard error == nil else {
                print("returned error")
                return
            }
            guard let content = data else {
                print("No data")
                return
            }
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String : Any] else {
                print("Not containing JSON")
                return
            }
            if let predictions = json["predictions"] as? [AnyObject] {
                for i in 0..<predictions.count {
                    
                    if let pred = predictions[i] as? [String : AnyObject] {
                        if let description = pred["description"] as? String {
                            self.suitableCities.append(description)
                            SaveCity(cities: self.suitableCities)
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.suitableCititesTableView.reloadData()
            }
        }
        task.resume()
    }
    
    private let closeAddVC: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(CloseAddVC), for: .touchUpInside)
        
        return button
    }()
    
    @objc func CloseAddVC() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        suitableCititesTableView.delegate = self
        suitableCititesTableView.dataSource = self
        view.backgroundColor = UIColor(white: 1, alpha: 0.99)
        [closeAddVC, searchTextField, suitableCititesTableView].forEach {view.addSubview($0)}

        closeAddVC.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 25), size: .init(width: 27, height: 27))
        searchTextField.anchor(top: closeAddVC.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 25, left: 25, bottom: 0, right: 25), size: .init(width: 0, height: 50))
        suitableCititesTableView.anchor(top: searchTextField.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
    }
}
