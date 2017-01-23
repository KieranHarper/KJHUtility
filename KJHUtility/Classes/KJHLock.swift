//
//  KJHLock.swift
//  Pods
//
//  Created by Kieran Harper on 23/1/17.
//
//

import Foundation

/**
 Simple lock class for concurrency synchronization that allows locking and unlocking from more than one thread. Similar to NSLock but useful when you want one thread to wait for another rather than protecting access. A semaphore of 1 is used internally.
 
 To have a process wait on another thread/queue, create an instance of the lock and lock it before the other work begins. After starting the other work, attempt to lock it again (which will cause the waiting). When the other work completes have it perform an unlock so that things can proceed.
 */
public class KJHLock: NSObject {
    
    private var _internalSemaphore = DispatchSemaphore(value: 1)
    
    deinit {
        _internalSemaphore.signal()
    }
    
    /**
     Aquire access to the lock, waiting if it is already locked by someone else.
     */
    public func lock() {
        _internalSemaphore.wait(timeout: .distantFuture)
    }
    
    /**
     Release the lock so that anyone waiting for it can proceed.
     */
    public func unlock() {
        _internalSemaphore.signal()
    }

    /**
     Syntactic sugar for Lock - will aquire the lock.
     */
    public func waitForUnlock() {
        
        // This is just syntactic sugar
        lock()
        unlock()
    }
}
