//
//  HourCell.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 24.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit

class HourCell: UICollectionViewCell {
    
    let hour: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .clear
        text.textAlignment = .center
        text.numberOfLines = 1
        return text
    }()
    
    let temperatureIcon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    let temperature: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .clear
        text.textAlignment = .center
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        LayOut()
    }
    
    private func LayOut() {
        
        let cellStackView = UIStackView(arrangedSubviews: [hour, temperatureIcon, temperature])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.axis = .vertical
        
    
        addSubview(cellStackView)
        cellStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cellStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cellStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cellStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        hour.topAnchor.constraint(equalTo: cellStackView.topAnchor).isActive = true
        hour.leadingAnchor.constraint(equalTo: cellStackView.leadingAnchor).isActive = true
        hour.trailingAnchor.constraint(equalTo: cellStackView.trailingAnchor).isActive = true
        hour.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        temperatureIcon.leadingAnchor.constraint(equalTo: cellStackView.leadingAnchor).isActive = true
        temperatureIcon.trailingAnchor.constraint(equalTo: cellStackView.trailingAnchor).isActive = true
        //temperatureIconView.topAnchor.constraint(equalTo: hourView.bottomAnchor).isActive = true
        temperatureIcon.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        temperature.leadingAnchor.constraint(equalTo: cellStackView.leadingAnchor).isActive = true
        temperature.trailingAnchor.constraint(equalTo: cellStackView.trailingAnchor).isActive = true
        //weatherView.topAnchor.constraint(equalTo: temperatureIconView.bottomAnchor).isActive = true
        temperature.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
