//
//  ViewController.swift
//  KeepinItSwift
//
//  Created by Daksh Sharma on 3/30/18.
//  Copyright © 2018 Daksh Sharma. All rights reserved.
//

import UIKit
import RealmSwift
import MaterialComponents

class ViewController: MDCCollectionViewController {

    private let CELL_ID = "MDCCARDSTYLE"

    var notes = [NoteCard]()
    lazy var realmNotes: Results<NoteCard> = {
        self.realm.objects(NoteCard.self)
    }()

    let realm = try! Realm()

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

    fileprivate func removeEmptyDataLabel() {
        noDataLabel.removeFromSuperview()
    }

    fileprivate func setupMDAppBar() {
        addChildViewController(appBar.headerViewController)
        // COLOR: Amber Orange
        appBar.headerViewController.headerView.backgroundColor = UIColor(hex: amberColor)
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
        bottomAppBar.floatingButton.backgroundColor = UIColor(hex: amberDark)
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
        print("BOTTOM BAR ADD NEW NOTE.....")
        let note = NoteCard()
        note.title = "T-Rex"
        note.note = "the city is over run by T-REX."
        note.tags = "World Problems"

        try! realm.write {
            realm.add(note)
        }
        updateRealmResultObject()
    }

    @objc func menuBottomAppBarAction(_ sender: UIButton!) {
        print("BOTTOM BAR MENU")
    }

    @objc func searchBottomAppBarAction(_ sender: UIButton!) {
        print("BOTTOM BAR SEARCH")
    }



    // MARK: Realm Database
    fileprivate func updateRealmResultObject() {
        realmNotes = realm.objects(NoteCard.self)
        self.collectionView?.reloadData()
        checkRealmDatabaseCount()
    }

    fileprivate func removeAllRealmData() {
        try! realm.write {
            realm.deleteAll()
        }
    }



    fileprivate func checkRealmDatabaseCount() {
        if realmNotes.count <= 0 {
            emptyDataLabelDisplay()
        } else {
            removeEmptyDataLabel()
        }
    }

    // MARK: MDC CollectionView Cell Styler
    fileprivate func setupMDCStyler() {
        styler.cellStyle = .card
        styler.cellLayoutType = .grid
        styler.gridPadding = 8
        styler.gridColumnCount = 2
    }


    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        removeAllRealmData()
        screenWidth = self.view.bounds.width
        screenHeight = self.view.bounds.height
        setupMDCStyler()
        checkRealmDatabaseCount()
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
        return realmNotes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath)

        if let textCell = cell as? MDCCollectionViewTextCell {
            let rn = realmNotes[indexPath.row]
            textCell.textLabel?.text = rn.title
            textCell.detailTextLabel?.text = rn.note
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, cellHeightAt indexPath: IndexPath) -> CGFloat {
        let cellHeight: CGFloat = 75
        return cellHeight
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(realmNotes[indexPath.row].title ?? "Olay")")
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

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        UIApplication.shared.statusBarBGColor?.backgroundColor = UIColor(hex: amberDark)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

