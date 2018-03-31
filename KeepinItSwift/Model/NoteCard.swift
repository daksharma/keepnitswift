//
//  NoteCard.swift
//  KeepinItSwift
//
//  Created by Daksh Sharma on 3/31/18.
//  Copyright © 2018 Daksh Sharma. All rights reserved.
//

import RealmSwift

class NoteCard: Object {
    @objc dynamic var title: String? = nil
    @objc dynamic var note: String? = nil
    @objc dynamic var tags: String? = nil
}
