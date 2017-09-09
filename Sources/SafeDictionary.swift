//
//  SafeDictionary.swift
//  Pods
//
//  Created by Kieran Harper on 12/1/17.
//
//

import Foundation

// The purpose of this class is to wrap a Dictionary and make it available via a concurrent read vs serial write mechanism so that it can be used safely withing multithreaded contexts. Because it's a wrapper, not all features of Dictionary are exposed, but many could be added if needed. You can also get an unsafe copy of the underlying dictionary whenever you want to get fancier with it.
// Dispatch barriers are used to ensure that write access waits until all other read operations are finished, and any enqueued read operations wait for the write to complete.
// NOTE: This has to be a class rather than a struct, due to the use of closures within queues, making this a little more different than a regular Dictionary.
public class SafeDictionary<Key : Hashable, Value>: NSObject {
    
    
    // MARK: - Private variables
    
    // Dictionary being wrapped
    private var _underlyingDict = Dictionary<Key, Value>()
    
    // GCD queue looking after access coordination
    private let _internalQueue = DispatchQueue(label: "SafeDictionaryInternal", attributes: .concurrent)
    
    
    
    // MARK: - Lifecycle
    
    // Create from a normal Dictionary
    public convenience init(fromUnsafeDictionary unsafeDict: Dictionary<Key, Value>) {
        self.init()
        _underlyingDict = unsafeDict
    }
    
    // Create from another SafeDictionary
    public convenience init(fromSafeDictionary safeDict: SafeDictionary<Key, Value>) {
        self.init()
        _underlyingDict = safeDict.toUnsafeDictionary()
    }
    
    // Copy the underlying dictionary for unsafe use (perhaps transitioning to a single threaded context)
    public func toUnsafeDictionary() -> Dictionary<Key, Value> {
        var toReturn: Dictionary<Key, Value> = [:]
        _internalQueue.sync {
            toReturn = _underlyingDict
        }
        return toReturn
    }
    
    
    
    // MARK: - Standard Dictionary operations
    
    public subscript(key: Key) -> Value? {
        get {
            var toReturn: Value? = nil
            _internalQueue.sync {
                toReturn = _underlyingDict[key]
            }
            return toReturn
        }
        set {
            _internalQueue.async(flags: .barrier) {
                self._underlyingDict[key] = newValue
            }
        }
    }
    
    public func removeValue(forKey key: Key) -> Value? {
        var toReturn: Value? = nil
        _internalQueue.sync(flags: .barrier) {
            toReturn = self._underlyingDict.removeValue(forKey: key)
        }
        return toReturn
    }
    
    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        _internalQueue.async(flags: .barrier) {
            self._underlyingDict.removeAll(keepingCapacity: keepCapacity)
        }
    }
    
    public var count: Int {
        var toReturn = 0
        _internalQueue.sync {
            toReturn = _underlyingDict.count
        }
        return toReturn
    }
    
    public var isEmpty: Bool {
        var toReturn = false
        _internalQueue.sync {
            toReturn = _underlyingDict.isEmpty
        }
        return toReturn
    }
    
    public override var description: String {
        var toReturn = ""
        _internalQueue.sync {
            toReturn =  _underlyingDict.description
        }
        return toReturn
    }
}
