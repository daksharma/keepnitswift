//
//  NoteCard.swift
//  KeepinItSwift
//
//  Created by Daksh Sharma on 3/31/18.
//  Copyright © 2018 Daksh Sharma. All rights reserved.
//

import RealmSwift

class NoteCard: Object {
    @objc dynamic var title: String!
    @objc dynamic var note: String!
    @objc dynamic var tags: [String]?
}
