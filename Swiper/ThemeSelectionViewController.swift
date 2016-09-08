//
//  ThemeSelectionViewController.swift
//  Swiper
//
//  Created by Matt Brenneke on 6/1/16.
//  Copyright © 2016 Matt Brenneke. All rights reserved.
//

import UIKit

protocol ThemeSelectedProtocol {
    func selectedTheme(_ theme: String)
}

class ThemeSelectionViewController : UICollectionViewController {
    var dataModel : Array<[String:String]>? = nil
    var delegate : ThemeSelectedProtocol? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        populateThemes()
    }

    func populateThemes() {
        guard let tableDataURL = Bundle.main.url(forResource: "puzzlepacks", withExtension: "json") else {
            return
        }
        guard let tableData = try? Data(contentsOf: tableDataURL) else {
            return
        }
        dataModel = try? JSONSerialization.jsonObject(with: tableData, options: .allowFragments) as! Array<[String:String]>
    }

    override func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        return IndexPath(item: 0, section: 0)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "themeCell", for: indexPath)
        if let themeCell = cell as? ThemeCell, let themeData = self.dataModel?[(indexPath as NSIndexPath).row] {
            themeCell.title?.text = themeData["title"]
            if let imageURL = Bundle.main.url(forResource: themeData["bundlestring"], withExtension: "jpg") {
                let imageData = try? Data(contentsOf: imageURL)
                themeCell.preview?.image = UIImage(data: imageData!)
            }
        }

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let theme = self.dataModel?[(indexPath as NSIndexPath).row] else {
            return
        }
        guard let themeId = theme["bundlestring"] else {
            return
        }

        self.delegate?.selectedTheme(themeId)
    }
}
