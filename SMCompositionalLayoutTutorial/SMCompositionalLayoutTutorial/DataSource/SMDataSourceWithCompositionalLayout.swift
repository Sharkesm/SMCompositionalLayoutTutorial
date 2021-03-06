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

        // Absolute item count
        // let itemsPerRow = index + 3
        // let fraction: CGFloat = (1 / CGFloat(itemsPerRow))

        let itemsPerRow = environment.traitCollection.horizontalSizeClass == .compact ? 3 : 6
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
    
    var nestedGroupLayout: UICollectionViewCompositionalLayout {
        
        let inset: CGFloat = 2.5
        
        // Larger Item
        let largestItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let largestItem = NSCollectionLayoutItem(layoutSize: largestItemSize)
        largestItem.contentInsets = .init(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // Smaller Item
        let smallestItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        let smalletItem = NSCollectionLayoutItem(layoutSize: smallestItemSize)
        smalletItem.contentInsets = .init(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // Groups
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [smalletItem])
        
        let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [largestItem, verticalGroup, verticalGroup])
        
        // Section
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.contentInsets = .init(top: inset, leading: inset, bottom: inset, trailing: inset)
        section.boundarySupplementaryItems = [sectionHeaderSupplementaryItem]
        section.orthogonalScrollingBehavior = .groupPaging
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    var animatedGroupedLayout: UICollectionViewCompositionalLayout {
        let fraction: CGFloat = 1.0 / 3.0
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 100, leading: 2.5, bottom: 0, trailing: 2.5)
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let layoutWidth = environment.container.contentSize.width
                let distanceFromCenter = abs((item.frame.midX - offset.x) - layoutWidth / 2.0)
                let minScale: CGFloat = 0.7
                let maxScale: CGFloat = 1.1
                let scale = max(maxScale - (distanceFromCenter / layoutWidth), minScale)
                item.transform = .init(scaleX: scale, y: scale)
            }
        }
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        let items: [Section.Item] = .init(repeating: .init(identifier: 10, title: "Title"), count: 10)
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
        collectionView.collectionViewLayout = animatedGroupedLayout
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
