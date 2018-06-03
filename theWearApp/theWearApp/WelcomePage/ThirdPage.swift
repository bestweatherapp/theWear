//
//  ThirdPage.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 03.06.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit

class ThirdPage: UICollectionViewCell {
    
    private let popUpView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        view.layer.cornerRadius = 30
        view.layer.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 80).cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowRadius = 5
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        LayOut()
    }
    
    func LayOut() {
        addSubview(popUpView)
        popUpView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 120, left: 50, bottom: 120, right: 50), size: .init())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

