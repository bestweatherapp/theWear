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
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    let view1: UIImageView = {
        let image = UIImageView()
        return image
    }()
    let view2: UIImageView = {
        let image = UIImageView(image: UIImage(named: "um"))
        return image
    }()
    let view3: UIImageView = {
        let image = UIImageView()
        return image
    }()
    let view4: UIImageView = {
        let image = UIImageView()
        return image
    }()
    let view5: UIImageView = {
        let image = UIImageView()
        return image
    }()
    let view6: UIImageView = {
        let image = UIImageView()
        return image
    }()
    let view7: UIImageView = {
        let image = UIImageView()
        return image
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
        [view1, view2, view3, view4, view5, view6, view7].forEach {clothes.addSubview($0)}
        view1.anchor(top: clothes.topAnchor, leading: clothes.leadingAnchor, bottom: clothes.bottomAnchor, trailing: nil, padding: .init(top: 2.5, left: 1.5, bottom: 2.5, right: 0), size: .init(width: 25, height: 25))
        view2.anchor(top: clothes.topAnchor, leading: view1.trailingAnchor, bottom: clothes.bottomAnchor, trailing: nil, padding: .init(top: 2.5, left: 1.5, bottom: 2.5, right: 0), size: .init(width: 25, height: 25))
        view3.anchor(top: clothes.topAnchor, leading: view2.trailingAnchor, bottom: clothes.bottomAnchor, trailing: nil, padding: .init(top: 2.5, left: 1.5, bottom: 2.5, right: 0), size: .init(width: 25, height: 25))
        view4.anchor(top: clothes.topAnchor, leading: view3.trailingAnchor, bottom: clothes.bottomAnchor, trailing: nil, padding: .init(top: 2.5, left: 1.5, bottom: 2.5, right: 0), size: .init(width: 25, height: 25))
        view5.anchor(top: clothes.topAnchor, leading: view4.trailingAnchor, bottom: clothes.bottomAnchor, trailing: nil, padding: .init(top: 2.5, left: 1.5, bottom: 2.5, right: 0), size: .init(width: 25, height: 25))
        view6.anchor(top: clothes.topAnchor, leading: view5.trailingAnchor, bottom: clothes.bottomAnchor, trailing: nil, padding: .init(top: 2.5, left: 1.5, bottom: 2.5, right: 0), size: .init(width: 25, height: 25))
        view7.anchor(top: clothes.topAnchor, leading: view6.trailingAnchor, bottom: clothes.bottomAnchor, trailing: clothes.trailingAnchor, padding: .init(top: 2.5, left: 0, bottom: 2.5, right: 0), size: .init(width: 25, height: 25))
        
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
        clothes.widthAnchor.constraint(equalToConstant: 106).isActive = true
        
        if view5.image == nil && view6.image == nil && view7.image == nil {
            clothes.isScrollEnabled = false
        } else {
            clothes.isScrollEnabled = true
        }
        
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
