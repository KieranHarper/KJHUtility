//
//  SafeArray.swift
//  Pods
//
//  Created by Kieran Harper on 12/1/17.
//
//

import UIKit

// The purpose of this class is to wrap an Array and make it available via a concurrent read vs serial write mechanism so that it can be used safely withing multithreaded contexts. Because it's a wrapper, not all features of Array are exposed, but many could be added if needed. You can also get an unsafe copy of the underlying array whenever you want to get fancier with it.
// Dispatch barriers are used to ensure that write access waits until all other read operations are finished, and any enqueued read operations wait for the write to complete.
// NOTE: This has to be a class rather than a struct, due to the use of closures within queues, making this a little more different than a regular Array.
public class SafeArray<Element>: CustomStringConvertible {
    
    
    // MARK: - Private variables
    
    // Array being wrapped
    private var _underlyingArray = Array<Element>()
    
    // GCD queue looking after access coordination
    private let _internalQueue = DispatchQueue(label: "SafeArrayInternal", attributes: .concurrent)
    
    
    
    // MARK: - Lifecycle
    
    // Create from a normal Array
    public convenience init(fromUnsafeArray unsafeArray: Array<Element>) {
        self.init()
        _underlyingArray = unsafeArray
    }
    
    // Create from another SafeArray
    public convenience init(fromSafeArray safeArray: SafeArray<Element>) {
        self.init()
        _underlyingArray = safeArray.toUnsafeArray()
    }
    
    // Copy the underlying array for unsafe use (perhaps transitioning to a single threaded context)
    public func toUnsafeArray() -> Array<Element> {
        var toReturn: Array<Element> = []
        _internalQueue.sync {
            toReturn = _underlyingArray
        }
        return toReturn
    }
    
    
    
    // MARK: - Safer Array operations
    
    // This will get an element ONLY when within range, otherwise returning nil.
    // If you pass nil for the setter it doubles as removeAtIndex
    public subscript(index: Int) -> Element? {
        get {
            var toReturn: Element? = nil
            _internalQueue.sync {
                if _underlyingArray.count > index {
                    toReturn = _underlyingArray[index]
                }
            }
            return toReturn
        }
        set {
            _internalQueue.async(flags: .barrier) {
                if let toInsert = newValue {
                    self._underlyingArray[index] = toInsert
                } else {
                    self._underlyingArray.remove(at: index)
                }
            }
        }
    }
    
    // Remove elements from the array that match a predicate, without multiple steps or dealing with any indexes
    public func remove(where predicate: @escaping (Element) -> Bool) {
        _internalQueue.async(flags: .barrier) {
            self._underlyingArray = self._underlyingArray.filter { !predicate($0) }
        }
    }
    
    
    
    // MARK: - Standard Array operations
    
    public func append(_ newElement: Element) {
        _internalQueue.async(flags: .barrier) {
            self._underlyingArray.append(newElement)
        }
    }
    
    public func removeLast() -> Element? {
        var toReturn: Element? = nil
        _internalQueue.sync(flags: .barrier) {
            toReturn = _underlyingArray.removeLast()
        }
        return toReturn
    }
    
    public func removeFirst() -> Element? {
        var toReturn: Element? = nil
        _internalQueue.sync(flags: .barrier) {
            toReturn = _underlyingArray.removeFirst()
        }
        return toReturn
    }
    
    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        _internalQueue.async(flags: .barrier) {
            self._underlyingArray.removeAll(keepingCapacity: keepCapacity)
        }
    }
    
    public func contains(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        var toReturn = false
        try _internalQueue.sync {
            toReturn = try _underlyingArray.contains(where: predicate)
        }
        return toReturn
    }
    
    public var count: Int {
        var toReturn = 0
        _internalQueue.sync {
            toReturn = _underlyingArray.count
        }
        return toReturn
    }
    
    public var isEmpty: Bool {
        var toReturn = false
        _internalQueue.sync {
            toReturn = _underlyingArray.isEmpty
        }
        return toReturn
    }
    
    public var description: String {
        var toReturn = ""
        _internalQueue.sync {
            toReturn =  _underlyingArray.description
        }
        return toReturn
    }
}
