//
//  FavoritesNavigationController.swift
//  Reciplease
//
//  Created by co5ta on 13/03/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// Controller of the navigation in  favorites  tab
class FavoritesNavigationController: UINavigationController {

    /// Root view controller
    let favoritesListVC = RecipeListViewController(mode: .favorites)
    
    /// Called after the controller's view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers.append(favoritesListVC)
        getFavorites()
    }
    
    /// Gets favorite recipes from storage
    private func getFavorites() {
        do { try Recipe.favorites = CoreDataService.shared.loadRecipes() }
        catch let error {
            let alert = UIAlertController.plainAlert(
                title: Strings.errorTitle,
                message: error.localizedDescription)
            present(alert, animated: true)
        }
    }

}
