//
//  Assets.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/31/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import UIKit

internal struct ImageAsset {
    internal fileprivate(set) var name: String
    
    internal var image: UIImage {
        let bundle = Bundle(for: BundleToken.self)
        let image = UIImage(named: name, in: bundle, compatibleWith: nil)
        
        guard let result = image else { fatalError("Unable to load image named \(name).") }
        return result
    }
}

enum Assets {
    static let imagePlaceholder = ImageAsset(name: "image_placeholder")
    static let buttles = ImageAsset(name: "buttles")
    static let random = ImageAsset(name: "random")
    static let favorite = ImageAsset(name: "favorite")
}

private final class BundleToken {}
