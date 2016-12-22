//: Playground - noun: a place where people can play

import UIKit

protocol TaskClass {
    func willStart()
    func didStart()
    func willFinish()
    func didFinish()
}

class Task: NSObject {
    
    enum State {
        
        enum RunningState {
            case notStarted
            case running
            case cancelling
        }
        
        enum CompletionState {
            case successful
            case cancelled
            case failed
        }
    }
    
    typealias CompletionHandler = (_ state: State)->()
    typealias ProgressHandler = (_ percent: Float)->()
    
    class func with(ID identifier: String) -> Task? {
        return nil
    }
    
    func cancel() {
        
    }
    
    func start() {
        
    }
    
    func start(afterTask task: Task, finishesWith states: [State.CompletionState] = []) {
        // (where empty means any state)
    }
    
    func onProgress(_ handler: ProgressHandler) {
        
    }
    
    func onCompletion(_ handler: CompletionHandler) {
        
    }
    
    init(withWork workBlock: ()->()) {
        super.init()
    }
    
    private override init() {
        super.init()
    }
    
    // autoretry?
}

class MultiTask: Task {
    var maxParallelTasks = 0 // (0 == unlimited)
    var stopIfAnyFail = false
    
    init(withTasks tasks: [Task]) {
        super.init {
            // (figure out how to run tasks together)
        }
    }
}

class SerialTask: MultiTask {
    override let maxParallelTasks {
        return 1
    }
}

class ParallelTask: MultiTask {
    
    init(withTasks tasks: [Task]) {
        super.init {
            // (chain the tasks together)
        }
    }
    
    var stopIfAnyFail = false
}

class CustomTask: Task {
    
}


let task = Task() {
    
}





Task.with(ID:"test")?.onProgress { (percent) in
    
}



