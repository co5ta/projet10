//
//  Recipe.swift
//  Reciplease
//
//  Created by co5ta on 18/03/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation

/// An object that stores  data of a recipe
struct Recipe {
    
    /// Recipe namess
    let title: String
    /// Recipe image url
    let pictureURL: String
    /// Recipe url
    let url: String
    /// Number of people
    let people: Float
    /// Health labels
    let healthLabels: [String]
    /// Cautions
    let cautionLabels: [String]
    /// Ingredients
    let ingredients: [String]
    
    
    /// List of all stored recipes
    static var favorites: [Recipe] = []
    /// Indicates if the list of favorites has changed
    static var favoritesListEdited = false
}

// MARK: - Decodable
extension Recipe: Decodable {
    
    ///  Init properties from json data
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let recipe = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .recipe)
        title = try recipe.decode(String.self, forKey: .title)
        pictureURL = try recipe.decode(String.self, forKey: .pictureURL)
        url = try recipe.decode(String.self, forKey: .url)
        people = try recipe.decode(Float.self, forKey: .people)
        healthLabels = try recipe.decode([String].self, forKey: .healthLabels)
        cautionLabels = try recipe.decode([String].self, forKey: .cautionLabels)
        ingredients = try recipe.decode([String].self, forKey: .ingredients)
    }
    
    /// Give keys to use for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case recipe
        case title = "label"
        case pictureURL = "image"
        case url
        case people = "yield"
        case healthLabels
        case cautionLabels = "cautions"
        case ingredients = "ingredientLines"
    }
}

// MARK: - Core Data
extension Recipe {
    
    /// Init properties from a NSManagedObject
    init(from recipeEntity: RecipeEntity) {
        self.title = recipeEntity.title ?? ""
        self.pictureURL = recipeEntity.pictureURL ?? ""
        self.url = recipeEntity.url ?? ""
        self.people = recipeEntity.people

        if let healthData = recipeEntity.healthLabels,
            let healthLabels = try? JSONDecoder().decode([String].self, from: healthData) {
            self.healthLabels = healthLabels
        } else { self.healthLabels = [] }
        
        if let cautionData = recipeEntity.cautionLabels,
            let cautionLabels = try? JSONDecoder().decode([String].self, from: cautionData) {
            self.cautionLabels = cautionLabels
        } else { self.cautionLabels = [] }
        
        if let ingredientsData = recipeEntity.ingredients,
            let ingredients = try? JSONDecoder().decode([String].self, from: ingredientsData) {
            self.ingredients = ingredients
        } else { self.ingredients = [] }
    }
}

// MARK: - Equatable
extension Recipe: Equatable {
    
    /// Compare equality between 2 Recipes
    static func == (left: Recipe, right: Recipe) -> Bool {
        return left.title == right.title && left.url == right.url
    }
}
