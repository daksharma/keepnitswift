//
//  AddNoteViewController.swift
//  KeepinItSwift
//
//  Created by Daksh Sharma on 4/1/18.
//  Copyright © 2018 Daksh Sharma. All rights reserved.
//

import UIKit
import RealmSwift
import MaterialComponents

class AddNoteViewController: UIViewController, UITextFieldDelegate {
    var titleTextField: MDCTextField = {
        var tf = MDCTextField()
        tf.placeholder = "Title"
        tf.cursorColor = UIColor(hex: amberColor)
        tf.underline?.color = UIColor(hex: amberColor)
        tf.contentHorizontalAlignment = .center
        tf.contentVerticalAlignment = .center
        return tf
    }()

    let noteTextField: MDCMultilineTextField = {
        let mtf = MDCMultilineTextField()
        mtf.placeholder = "Notes..."
        mtf.cursorColor = UIColor(hex: amberColor)
        mtf.underline?.color = UIColor(hex: amberColor)
        mtf.textView?.textContainer.maximumNumberOfLines = 3
        return mtf
    }()

    let tagsTextField: MDCTextField = {
        let tf = MDCTextField()
        tf.placeholder = "Work, Personal..."
        tf.cursorColor = UIColor(hex: amberColor)
        tf.underline?.color = UIColor(hex: amberColor)
        tf.contentHorizontalAlignment = .center
        tf.contentVerticalAlignment = .center
        return tf
    }()

    let raisedButton: MDCRaisedButton = {
        let rb = MDCRaisedButton()
        rb.setElevation(ShadowElevation(rawValue: 4), for: .normal)
        rb.backgroundColor = UIColor(hex: amberDark)
        rb.setTitle("Add Note", for: .normal)
        rb.contentVerticalAlignment = .center
        rb.contentHorizontalAlignment = .center
        rb.sizeToFit()
        return rb
    }()

    let frontSafeZone: CGFloat = 20
    let trailingSafeZone: CGFloat = 40
    let tfHeight: CGFloat = 70
    let realm = try! Realm()
    


    fileprivate func setupTitleTextView() {
        titleTextField.frame = CGRect(x: frontSafeZone, y: frontSafeZone,
                                      width: self.view.frame.width - trailingSafeZone,
                                      height: tfHeight)
        titleTextField.delegate = self
        view.addSubview(titleTextField)
    }

    fileprivate func setupNoteTextView() {
        noteTextField.frame = CGRect(x: frontSafeZone, y: 100,
                                     width: self.view.frame.width - trailingSafeZone,
                                     height: tfHeight)
        noteTextField.textView?.delegate = self as? UITextViewDelegate
        view.addSubview(noteTextField)
    }

    fileprivate func setupTagsTextView() {
        tagsTextField.frame = CGRect(x: frontSafeZone, y: 200,
                                     width: self.view.frame.width - trailingSafeZone,
                                     height: tfHeight)
        tagsTextField.delegate = self
        view.addSubview(tagsTextField)
    }

    @objc func addNewNoteToRealm(_ button: UIButton!) {
        print("ADD NEW NOTE BUTTON")
        let note = NoteCard()
        note.title = titleTextField.text
        note.note = noteTextField.textView?.text
        note.tags = tagsTextField.text
        try! realm.write {
            realm.add(note)
        }
        NotificationCenter.default.post(name: .reload, object: nil)
        self.dismiss(animated: true, completion: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupTitleTextView()
        setupNoteTextView()
        setupTagsTextView()
        raisedButton.frame = CGRect(x: 0, y: 300, width: self.view.frame.width, height: 70)
        raisedButton.addTarget(self, action: #selector(addNewNoteToRealm(_:)), for: .touchUpInside)
        view.addSubview(raisedButton)
    }
}
