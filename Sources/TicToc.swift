//
//  TicToc.swift
//  Pods
//
//  Created by Kieran Harper on 3/1/17.
//
//

import Foundation

public class TicToc: NSObject {
    
    public private(set) var name: String?
    private var _startTimestamp: UInt64 = 0
    private var _checkpointIndex = 0
    private var _lastCheckpointToc: TimeInterval = 0
    
    private struct Statics {
        static var hostTicksToSeconds: Double?
    }
    
    override private convenience init() {
        self.init(name: nil)
    }
    
    private init(name: String?) {
        super.init()
        self.name = name
        
        // Setup things we'll need later (if we haven't done it already - static)
        if Statics.hostTicksToSeconds == nil {
            var t = mach_timebase_info_data_t()
            mach_timebase_info(&t)
            Statics.hostTicksToSeconds = (Double(t.numer) / Double(t.denom)) * 1.0e-9
        }
        
        // Record the current time
        _startTimestamp = mach_absolute_time()
    }
    
    public class func tic() -> TicToc {
        return TicToc()
    }
    
    public class func tic(withName name: String) -> TicToc {
        return TicToc(name: name)
    }
    
    public func toc() {
        let time = getTime()
        if let name = name {
            NSLog("Toc - %@: %f",name,time)
        } else {
            NSLog("Toc: %f",time)
        }
    }
    
    public func checkpoint() {
        let time = getTime()
        let checkpointTime = time - _lastCheckpointToc
        _lastCheckpointToc = time
        if let name = name {
            NSLog("Toc - %@ #%d: %f",name,_checkpointIndex,checkpointTime)
        } else {
            NSLog("Toc #%ld: %f",_checkpointIndex,checkpointTime)
        }
        _checkpointIndex = _checkpointIndex + 1
    }
    
    private func getTime() -> TimeInterval {
        return Double(mach_absolute_time() - _startTimestamp) * Statics.hostTicksToSeconds!
    }
}
