//
//  DayCell.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 24.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {
    
    let date: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .clear
        text.sizeToFit()
        text.textAlignment = .left
        text.numberOfLines = 2
        return text
    }()
    
    let clothes: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .red
        return view
    }()
    
    let temperatureIcon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    let temperature: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .clear
        text.sizeToFit()
        text.textAlignment = .right
        return text
    }()
    
    private func LayOut() {

        let cellStackView = UIStackView(arrangedSubviews: [date, clothes, temperatureIcon, temperature])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.distribution = .equalCentering
        cellStackView.axis = .horizontal
        addSubview(cellStackView)
        
        cellStackView.topAnchor.constraint(equalTo: topAnchor, constant: 18).isActive = true
        cellStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        cellStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18).isActive = true
        cellStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        date.topAnchor.constraint(equalTo: cellStackView.topAnchor).isActive = true
        date.leadingAnchor.constraint(equalTo: cellStackView.leadingAnchor).isActive = true
        date.bottomAnchor.constraint(equalTo: cellStackView.bottomAnchor).isActive = true
        
        clothes.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        clothes.heightAnchor.constraint(equalToConstant: 30).isActive = true
        clothes.leadingAnchor.constraint(equalTo: date.trailingAnchor).isActive = true
        clothes.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        temperatureIcon.trailingAnchor.constraint(equalTo: temperature.leadingAnchor, constant: -5).isActive = true
        temperatureIcon.centerYAnchor.constraint(equalTo: cellStackView.centerYAnchor).isActive = true
        temperatureIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        temperatureIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        temperature.trailingAnchor.constraint(equalTo: cellStackView.trailingAnchor).isActive = true
        temperature.topAnchor.constraint(equalTo: cellStackView.topAnchor).isActive = true
        temperature.bottomAnchor.constraint(equalTo: cellStackView.bottomAnchor).isActive = true
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        LayOut()
        print(cl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
