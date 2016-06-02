//
//  ThemeSelectionViewController.swift
//  Swiper
//
//  Created by Matt Brenneke on 6/1/16.
//  Copyright © 2016 Matt Brenneke. All rights reserved.
//

import UIKit

protocol ThemeSelectedProtocol {
    func selectedTheme(theme: String)
}

class ThemeSelectionViewController : UICollectionViewController {
    var dataModel : Array<[String:String]>? = nil
    var delegate : ThemeSelectedProtocol? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        populateThemes()
    }

    func populateThemes() {
        guard let tableDataURL = NSBundle.mainBundle().URLForResource("puzzlepacks", withExtension: "json") else {
            return
        }
        guard let tableData = NSData(contentsOfURL: tableDataURL) else {
            return
        }
        dataModel = try? NSJSONSerialization.JSONObjectWithData(tableData, options: .AllowFragments) as! Array<[String:String]>
    }

    override func indexPathForPreferredFocusedViewInCollectionView(collectionView: UICollectionView) -> NSIndexPath? {
        return NSIndexPath(forItem: 0, inSection: 0)
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel?.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("themeCell", forIndexPath: indexPath)
        if let themeCell = cell as? ThemeCell, themeData = self.dataModel?[indexPath.row] {
            themeCell.title?.text = themeData["title"]
            if let imageURL = NSBundle.mainBundle().URLForResource(themeData["bundlestring"], withExtension: "jpg") {
                let imageData = NSData(contentsOfURL: imageURL)
                themeCell.preview?.image = UIImage(data: imageData!)
            }
        }

        return cell
    }

    override func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let theme = self.dataModel?[indexPath.row] else {
            return
        }
        guard let themeId = theme["bundlestring"] else {
            return
        }

        self.delegate?.selectedTheme(themeId)
    }
}
