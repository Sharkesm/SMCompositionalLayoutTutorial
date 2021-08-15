//
//  BackgroundSupplementaryView.swift
//  SMCompositionalLayoutTutorial
//
//  Created by Manase on 15/08/2021.
//

import UIKit

class BackgroundSupplementaryView: UICollectionReusableView {
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 8
        backgroundColor = .init(white: 0.85, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
