//
//  AppendCollection.swift
//  BDModules
//
//  Created by Patrick Hogan on 12/6/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import Foundation

public func +=<T> (inout left: Set<T>, right: Set<T>) -> Set<T> {
    for t in right {
        left.insert(t)
    }
    return left
}

public func +=<T> (inout left: Array<T>, right: Array<T>) -> Array<T> {
    for t in right {
        left.append(t)
    }
    return left
}

public func +=<T> (inout left: Set<T>, right: Array<T>) -> Set<T> {
    for t in right {
        left.insert(t)
    }
    return left
}

public func +=<T> (inout left: Array<T>, right: Set<T>) -> Array<T> {
    for t in right {
        left.append(t)
    }
    return left
}

public func +=<K, V> (inout left: Dictionary<K, V>, right: Dictionary<K, V>) -> Dictionary<K, V> {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
    return left
}
