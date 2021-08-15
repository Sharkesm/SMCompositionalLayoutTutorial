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
    
    var sectionHeaderSupplementaryItem: NSCollectionLayoutBoundarySupplementaryItem {
        // Supplementary
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        header.pinToVisibleBounds = true
    
        return header
    }
    
    var headerSupplementaryItem: NSCollectionLayoutBoundarySupplementaryItem {
        // Supplementary Item
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let headerAnchor = NSCollectionLayoutAnchor(edges: .bottom, absoluteOffset: .zero)
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "new-photo", containerAnchor: headerAnchor)
        
        return headerItem
    }
    
    // Compsotional layout with decorated sections and items
    var layout: UICollectionViewLayout {
        let fraction: CGFloat = 1/3
        let inset: CGFloat = 2.5
        let sectionInset: CGFloat = 16
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [headerSupplementaryItem])
        item.contentInsets = .init(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section Background Item
        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: "SectionBackground")
        let backgroundInset: CGFloat = 8
        backgroundItem.contentInsets = .init(top: backgroundInset, leading: backgroundInset, bottom: backgroundInset, trailing: backgroundInset)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: sectionInset, leading: sectionInset, bottom: sectionInset, trailing: sectionInset)
        section.boundarySupplementaryItems = [sectionHeaderSupplementaryItem]
        section.decorationItems = [backgroundItem]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.register(BackgroundSupplementaryView.self, forDecorationViewOfKind: "SectionBackground")
        
        return layout
    }
    
    var sectionLayout = UICollectionViewCompositionalLayout { index, environment in
        let itemsPerRow = index + 3
        let fraction: CGFloat = (1 / CGFloat(itemsPerRow))
        let inset: CGFloat = 2.5
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // Supplementary Item
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [headerItem]
        
        return section
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
        collectionView.collectionViewLayout = sectionLayout
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
