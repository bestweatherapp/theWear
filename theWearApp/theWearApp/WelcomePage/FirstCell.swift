//
//  PageCell.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 23.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit

class FirstCell: UICollectionViewCell {
    
    private let popUpView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "page1"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        let attributedText = NSMutableAttributedString(string: "The powerful programming language that is also easy to learn.", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18)])
        textView.attributedText = attributedText
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(popUpView)
        popUpView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        popUpView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        popUpView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        popUpView.heightAnchor.constraint(equalToConstant: 450).isActive = true
        
        popUpView.addSubview(photoImageView)
        popUpView.addSubview(descriptionTextView)
        
        photoImageView.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        photoImageView.topAnchor.constraint(equalTo: popUpView.topAnchor, constant: 55).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        descriptionTextView.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor, constant: -55).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor, constant: 15).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -15).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 170).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
