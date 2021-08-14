//
//  ViewController.swift
//  SMCompositionalLayoutTutorial
//
//  Created by Manase on 14/08/2021.
//

import UIKit

class ViewController: UIViewController {

    var collectionView: UICollectionView?
    var dataSource: SMDataSourceProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = .init(frame: .zero, collectionViewLayout: .init())
        collectionView?.backgroundColor = .white
        
        if let collectionView = collectionView {
            dataSource = SMDataSourceWithCompositionalLayout(collectionView: collectionView)
            
            view.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .zero),
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .zero),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .zero),
                collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: .zero)
            ])
        }
    }
}

