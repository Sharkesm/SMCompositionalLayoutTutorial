//
//  SMDataSourceWithFlowLayout.swift
//  SMCompositionalLayoutTutorial
//
//  Created by Manase on 15/08/2021.
//

import Foundation
import UIKit

protocol SMDataSourceProtocol: NSObject {
    var layout: UICollectionViewLayout { get }
    
    func configCollectionView()
    func registerCells()
    func reload()
}

class SMDataSourceWithFlowLayout: NSObject, SMDataSourceProtocol {
    
    struct Section {
        let items: [Item]
        
        struct Item {
            let identifier: Int
            let title: String
        }
    }
    
    var collectionView: UICollectionView!
    let sections: [Section]
    
    var layout: UICollectionViewLayout {
        // Flow layout 
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 5
        flowLayout.sectionInset = .init(top: 5, left: 5, bottom: 5, right: 5)
        return flowLayout
    }
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        let items: [Section.Item] = .init(repeating: .init(identifier: 10, title: "Title"), count: 8)
        self.sections = .init(repeating: .init(items: items), count: 5)
        super.init()
        configCollectionView()
        registerCells()
    }
    
    func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    
        /// Compsotional layout
        collectionView.collectionViewLayout = layout
    }

    func registerCells() {
        collectionView.register(UINib.init(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Photo")
    }

    @objc func invalidateLayoutAndReload(_ state: Bool = false) {
        layout.invalidateLayout()
        if state { reload() }
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    func configTraitObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(invalidateLayoutAndReload(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
}

extension SMDataSourceWithFlowLayout: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
}

extension SMDataSourceWithFlowLayout: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath) as! PhotoCollectionViewCell
    }
}

extension SMDataSourceWithFlowLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numOfItemsPerRow: CGFloat = 3
        let spacing: CGFloat = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0
        let availableSpace: CGFloat = width - spacing * (numOfItemsPerRow + 1)
        let itemDimension = floor(availableSpace / numOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension)
    }
}
