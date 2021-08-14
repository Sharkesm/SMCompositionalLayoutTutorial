//
//  Autolayout+Extensions.swift
//  SMCompositionalLayoutTutorial
//
//  Created by Manase on 14/08/2021.
//

import UIKit

enum AutoLayoutKind {
    case leading(CGFloat)
    case top(CGFloat)
    case trailing(CGFloat)
    case bottom(CGFloat)
    case midCenter
    case centerHorizontally
    case centerVertically
    
    var paddingValue: CGFloat {
        switch self {
        case .leading(let padding):
            return padding
        case .top(let padding):
            return padding
        case .trailing(let padding):
            return padding
        case .bottom(let padding):
            return padding
        default:
            return 0.0
        }
    }
}

typealias AutoLayouts = [AutoLayoutKind]

extension UIView {

    func prepareViewForAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout(to parent: UIView, constraints: AutoLayouts) {
        prepareViewForAutoLayout()
        
        let layouts = constraints.map { layout -> NSLayoutConstraint in
            switch layout {
            case .leading:
                return NSLayoutConstraint.init(item: self, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1.0, constant: layout.paddingValue)
            case .top:
                return NSLayoutConstraint.init(item: self, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1.0, constant: layout.paddingValue)
            case .trailing:
                return NSLayoutConstraint.init(item: self, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1.0, constant: layout.paddingValue)
            case .bottom:
                return NSLayoutConstraint.init(item: self, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1.0, constant: layout.paddingValue)
            default:
                return NSLayoutConstraint.init(item: self, attribute: .centerX, relatedBy: .equal, toItem: parent, attribute: .centerX, multiplier: 1.0, constant: layout.paddingValue)
            }
        }
        
        NSLayoutConstraint.activate(layouts)
    }
}
