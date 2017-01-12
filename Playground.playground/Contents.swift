//: Playground - noun: a place where people can play

import Foundation

public class SafeDictionary<Key : Hashable, Value>: CustomStringConvertible {
    
    private var _underlyingDict = Dictionary<Key, Value>()
    private let _internalQueue = DispatchQueue(label: "SafeDictionaryInternal", attributes: .concurrent)
    
    public convenience init(fromUnsafeDictionary unsafeDict: Dictionary<Key, Value>) {
        self.init()
        _underlyingDict = unsafeDict
    }
    
    public convenience init(fromSafeDictionary safeDict: SafeDictionary<Key, Value>) {
        self.init()
        _underlyingDict = safeDict.toUnsafeDictionary()
    }
    
    public func toUnsafeDictionary() -> Dictionary<Key, Value> {
        var toReturn: Dictionary<Key, Value> = [:]
        _internalQueue.sync {
            toReturn = _underlyingDict
        }
        return toReturn
    }
    
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
    
    public var description: String {
        var toReturn = ""
        _internalQueue.sync {
            toReturn =  _underlyingDict.description
        }
        return toReturn
    }
}


var a = SafeDictionary<String, Int>()

a["test"] = 2
let b = a["test"]
a["asdf"] = 32
print(a)
a.removeAll()
print(a)
a["yeah"] = 55
print(a)
a["bleh"] = 123
print(a)
let c = a.removeValue(forKey: "yeah")

let another = SafeDictionary<String, Int>(fromUnsafeDictionary: a.toUnsafeDictionary())
another["haha"] = 1
print(another)
print(a)