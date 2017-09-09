//
//  DelayableForLoop.swift
//  KJHUtility
//
//  Created by Kieran Harper on 23/1/17.
//
//

import Foundation

public class DelayableForLoop: NSObject {
    
    override private init() { super.init() }
    
    public class func loop<T>(throughItems items: Array<T>, delayBetweenLoops: TimeInterval, initialDelay: TimeInterval = 0, itemHandler: @escaping (T)->(), completionHandler: @escaping ()->()) {
        
        // Create instance to do the work
        let worker = DelayableForLoop()
        
        // Begin the work after any provided start delay
        worker.processNext(inItems: items, afterDelay: initialDelay, delayToUseNext: delayBetweenLoops, itemHandler: itemHandler, completionHandler: completionHandler)
    }
    
    private func processNext<T>(inItems items: Array<T>, afterDelay delay: TimeInterval, delayToUseNext: TimeInterval, itemHandler: @escaping (T)->(), completionHandler: @escaping ()->()) {
        
        // Get the next item if there is one, otherwise finish immediately
        var workingItems = items
        guard let nextItem = workingItems.first else {
            completionHandler()
            return
        }
        
        // Wait the delay
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            
            // Do the work and proceed
            itemHandler(nextItem)
            workingItems.remove(at: 0)
            self.processNext(inItems: workingItems, afterDelay: delayToUseNext, delayToUseNext: delayToUseNext, itemHandler: itemHandler, completionHandler: completionHandler)
        }
    }
}
