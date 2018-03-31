//
//  ViewController.swift
//  KeepinItSwift
//
//  Created by Daksh Sharma on 3/30/18.
//  Copyright © 2018 Daksh Sharma. All rights reserved.
//

import UIKit
import MaterialComponents

class ViewController: MDCCollectionViewController {

    private let CELL_ID = "MDCCARDSTYLE"
    let animals = ["Lions", "Tigers", "Bears", "Monkeys"]

    let appBar = MDCAppBar()


    fileprivate func setupMDAppBar() {
        addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = UIColor(red: 1.0,
                                                                         green: 0.76,
                                                                         blue: 0.03,
                                                                         alpha: 1.0)
        appBar.headerViewController.headerView.trackingScrollView = self.collectionView
        appBar.navigationBar.tintColor = UIColor.black
        title = "Mareial Components"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        styler.cellStyle = .card
        collectionView?.register(MDCCollectionViewTextCell.self, forCellWithReuseIdentifier: CELL_ID)
        setupMDAppBar()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animals.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath)

        if let textCell = cell as? MDCCollectionViewTextCell {
            textCell.textLabel?.text = animals[indexPath.row]
        }
        return cell
    }

}

