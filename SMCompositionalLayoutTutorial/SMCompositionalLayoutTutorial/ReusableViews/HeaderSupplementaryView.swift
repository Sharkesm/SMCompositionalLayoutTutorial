//
//  HeaderSupplementaryView.swift
//  SMCompositionalLayoutTutorial
//
//  Created by Manase on 15/08/2021.
//

import UIKit

class HeaderSupplementaryView: UICollectionReusableView {

    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
    func config(_ title: String) {
        headerLabel.text = title
    }
}
