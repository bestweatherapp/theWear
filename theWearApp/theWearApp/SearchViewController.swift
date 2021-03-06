//
//  SearchViewController.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 24.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
        NotificationCenter.default.post(name: Notification.Name(rawValue: "closeSVC"), object: nil, userInfo: ["name":self.suitableCities[(suitableCititesTableView.indexPathForSelectedRow?.row)!].folding(options: .diacriticInsensitive, locale: .current)])
    }
    
    private let googleLogo: UIImageView = {
        let image = UIImageView(image: UIImage(named: "123"))
        return image
    }()
    
    private let topLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.dark
        return line
    }()
    
    private let bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.dark
        return line
    }()
    
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
    
    private let searchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        view.layer.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 80).cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowRadius = 5
        return view
    }()
    
    private let closeSearchViewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "closeGray"), for: .normal)
        button.addTarget(self, action: #selector(CloseSearchVC), for: .touchUpInside)
        return button
    }()
    
    private let suitableCititesTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    @objc func CloseSearchVC() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "closeSVCA"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let methods = Methods()
        pendingRequestWorkItem?.cancel()
        let text = textField.text
        if (methods.ContainsCyrillyc(text: text!) == true) {
            textField.text = ""
            self.suitableCititesTableView.dataSource = nil
            self.suitableCititesTableView.reloadData()
            return
        } else {
            self.suitableCititesTableView.dataSource = self
            let correctText = text?.folding(options: .diacriticInsensitive, locale: .current)
            let requestWorkitem = DispatchWorkItem {[weak self] in
            self?.suitableCities = [String]()
            self?.suitableCititesTableView.reloadData()
            self?.SuitableCitiesRequest(inputText: correctText!)
        }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: requestWorkitem)
            pendingRequestWorkItem = requestWorkitem

        }
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
    
    private func LayOut() {
        view.addSubview(searchView)
        [closeSearchViewButton, searchTextField, suitableCititesTableView, topLine, bottomLine, googleLogo].forEach {searchView.addSubview($0)}
        
        topLine.anchor(top: closeSearchViewButton.bottomAnchor, leading: searchView.leadingAnchor, bottom: nil, trailing: searchView.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0.5))
        bottomLine.anchor(top: searchTextField.bottomAnchor, leading: searchView.leadingAnchor, bottom: nil, trailing: searchView.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0.5))
        closeSearchViewButton.anchor(top: searchView.topAnchor, leading: nil, bottom: nil, trailing: searchView.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 25), size: .init(width: 25, height: 25))
        
        searchView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        searchView.heightAnchor.constraint(equalToConstant: 450).isActive = true
        searchView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        searchTextField.anchor(top: topLine.bottomAnchor, leading: searchView.leadingAnchor, bottom: nil, trailing: searchView.trailingAnchor, padding: .init(top: 5, left: 25, bottom: 0, right: 25), size: .init(width: 0, height: 35))
        suitableCititesTableView.anchor(top: bottomLine.bottomAnchor, leading: searchView.leadingAnchor, bottom: googleLogo.topAnchor, trailing: searchView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init())
        googleLogo.anchor(top: nil, leading: nil, bottom: searchView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 10, right: 0), size: .init(width: 125, height: 18))
        googleLogo.centerXAnchor.constraint(equalTo: searchView.centerXAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedOutside()
        view.backgroundColor = .clear
        suitableCititesTableView.delegate = self
        suitableCititesTableView.dataSource = self
        LayOut()
    }

    
}


    

