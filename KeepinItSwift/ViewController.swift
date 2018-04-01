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

    let note1: NoteCard = {
        let n1 = NoteCard()
        n1.title = "MD Components"
        n1.note = "Practicing Material Design Components."
        n1.tags = "Personal"
        return n1
    }()

    let note2: NoteCard = {
        let n2 = NoteCard()
        n2.title = "Realm Database"
        n2.note = "Working together with MD Components and Realm DB."
        n2.tags = "Project"
        return n2
    }()

    let note3: NoteCard = {
        let n3 = NoteCard()
        n3.title = "Practice Interview"
        n3.note = "Go through algorithms and data structures for interview problems."
        n3.tags = "Work"
        return n3
    }()

    var notes = [NoteCard]()

    func sampleData() {
        notes.append(note1)
        notes.append(note2)
        notes.append(note3)
    }

    let noDataLabel: UILabel = {
        let nd =  UILabel()
        nd.text = "Looks like you have no notes to keep.\nLet's add them"
        nd.numberOfLines = 3
        nd.textColor = UIColor.black
        nd.backgroundColor = UIColor.clear
        return nd
    }()

    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    let appBar = MDCAppBar()
    let bottomAppBar = MDCBottomAppBarView()

    fileprivate func emptyDataLabelDisplay() {
        noDataLabel.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        noDataLabel.textAlignment = .center
        self.view.addSubview(noDataLabel)
    }

    fileprivate func setupMDAppBar() {
        addChildViewController(appBar.headerViewController)
        // COLOR: Amber Orange
        appBar.headerViewController.headerView.backgroundColor = UIColor(hex: "FFC107")
        appBar.headerViewController.headerView.trackingScrollView = self.collectionView
        appBar.navigationBar.tintColor = UIColor.black
        appBar.addSubviewsToParent()
        title = Bundle.main.displayName
    }

    fileprivate func setupBottomAppBar() {
        let barSize = appBar.headerViewController.headerView.bounds.height + 20
        let bottomYAxis = self.view.bounds.height - barSize
        bottomAppBar.frame = CGRect(x: 0, y: bottomYAxis, width: screenWidth, height: barSize)
        setupBottomAppBarFloatingButton()
        setupBottomAppBarMenuButton()
        setupBottomAppBarSearchButton()
        self.view.addSubview(bottomAppBar)
    }

    fileprivate func setupBottomAppBarFloatingButton() {
        let barAddImage = UIImage(named: "ic_add")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        bottomAppBar.floatingButton.addTarget(self,
                                              action: #selector(addNoteFBAction(_:)),
                                              for: .touchUpInside)
        bottomAppBar.floatingButton.setImage(barAddImage, for: .normal)
        bottomAppBar.floatingButton.backgroundColor = UIColor.white
        bottomAppBar.floatingButton.tintColor = UIColor.black
    }

    fileprivate func setupBottomAppBarMenuButton() {
        let barMenuImage = UIImage(named: "ic_menu")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let barMenuItem = UIBarButtonItem(image: barMenuImage,
                                          style: .plain,
                                          target: self,
                                          action: #selector(menuBottomAppBarAction(_:)))
        bottomAppBar.leadingBarButtonItems = [barMenuItem]
    }

    fileprivate func setupBottomAppBarSearchButton() {
        let barSearchImage = UIImage(named: "ic_search")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let barSearchItem = UIBarButtonItem(image: barSearchImage,
                                            style: .plain,
                                            target: self,
                                            action: #selector(searchBottomAppBarAction(_:)))

        barSearchItem.image = barSearchImage
        bottomAppBar.trailingBarButtonItems = [barSearchItem]
    }




    // MARK: Button Handlers
    @objc func addNoteFBAction(_ sender: UIButton!) {
        print("BOTTOM BAR ADD NOTE")
    }

    @objc func menuBottomAppBarAction(_ sender: UIButton!) {
        print("BOTTOM BAR MENU")
    }

    @objc func searchBottomAppBarAction(_ sender: UIButton!) {
        print("BOTTOM BAR SEARCH")
    }





    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        screenWidth = self.view.bounds.width
        screenHeight = self.view.bounds.height
        sampleData()
        if notes.count <= 0 {
            emptyDataLabelDisplay()
        }
        styler.cellStyle = .card
        collectionView?.register(MDCCollectionViewTextCell.self,
                                 forCellWithReuseIdentifier: CELL_ID)
        setupMDAppBar()
        setupBottomAppBar()
    }




    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath)

        if let textCell = cell as? MDCCollectionViewTextCell {
            textCell.textLabel?.text = notes[indexPath.row].title
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(notes[indexPath.row].title ?? "Olay")")
    }




    // MARK: UIScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == appBar.headerViewController.headerView.trackingScrollView {
            appBar.headerViewController.headerView.trackingScrollDidScroll()
        }
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == appBar.headerViewController.headerView.trackingScrollView {
            appBar.headerViewController.headerView.trackingScrollDidEndDecelerating()
        }
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == appBar.headerViewController.headerView.trackingScrollView {
            let headerView = appBar.headerViewController.headerView
            headerView.trackingScrollDidEndDraggingWillDecelerate(decelerate)
        }
    }

    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == appBar.headerViewController.headerView.trackingScrollView {
            let headerView = appBar.headerViewController.headerView
            headerView.trackingScrollWillEndDragging(withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

