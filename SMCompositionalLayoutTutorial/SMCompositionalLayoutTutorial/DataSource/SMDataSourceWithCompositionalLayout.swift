//
//  SMDataSourceWithCompositionalLayout.swift
//  SMCompositionalLayoutTutorial
//
//  Created by Manase on 14/08/2021.
//

import Foundation
import UIKit

class SMDataSourceWithCompositionalLayout: NSObject, SMDataSourceProtocol {
    
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
        let fraction: CGFloat = 1/3
        let inset: CGFloat = 2.5
        
        // Supplementary
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        header.pinToVisibleBounds = true
        
        // Supplementary Item
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let headerAnchor = NSCollectionLayoutAnchor(edges: .bottom, absoluteOffset: .zero)
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "new-photo", containerAnchor: headerAnchor)
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [headerItem])
        item.contentInsets = .init(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: inset, leading: inset, bottom: inset, trailing: inset)
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        let items: [Section.Item] = .init(repeating: .init(identifier: 10, title: "Title"), count: 9)
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
        collectionView.register(.init(nibName: "HeaderSupplementaryView", bundle: nil), forSupplementaryViewOfKind: "header", withReuseIdentifier: "HeaderSupplementaryView")
        collectionView.register(.init(nibName: "NewPhotoSupplementaryView", bundle: nil), forSupplementaryViewOfKind: "new-photo", withReuseIdentifier: "NewPhotoSupplementaryView")
    }

    func reload() {
        collectionView.reloadData()
    }
}

extension SMDataSourceWithCompositionalLayout: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
}


extension SMDataSourceWithCompositionalLayout: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath) as! PhotoCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case "header":
            let headerSupplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSupplementaryView", for: indexPath) as! HeaderSupplementaryView
            
            headerSupplementaryView.config("Header-(\(indexPath.section + 1))")
            return headerSupplementaryView
        case "new-photo":
            let bannerSupplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NewPhotoSupplementaryView", for: indexPath) as! NewPhotoSupplementaryView
            bannerSupplementaryView.isHidden = indexPath.row % 5 != 0 // Show on every 5th item
            return bannerSupplementaryView
        default:
            assertionFailure("Unexpected element kind: \(kind)")
            return UICollectionReusableView()
        }
    }
}
