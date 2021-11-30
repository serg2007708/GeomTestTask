//
//  NavigationItem+ColorFix.swift
//  GeoTestTask
//
//  Created by Sergiy Sobol on 30.11.2021.
//

import UIKit

extension UINavigationItem {
    func applyColorFix() {
        // Navbar color fix for XCode 13
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .white
        standardAppearance = barAppearance
        scrollEdgeAppearance = barAppearance
    }
}
