//
//  extensions.swift
//  KeepinItSwift
//
//  Created by Daksh Sharma on 3/31/18.
//  Copyright © 2018 Daksh Sharma. All rights reserved.
//
import Foundation

extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}
