//: Playground - noun: a place where people can play

import UIKit

protocol TaskClass {
    func doWork()
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
    typealias TaskCompleteBlock = (_ state: State.CompletionState)->()
    typealias TaskWorkBlock = (_ complete: TaskCompleteBlock)->()
    
    final class func with(ID identifier: String) -> Task? {
        return nil
    }
    
    final func cancel() {
        
    }
    
    final func start() {
        if let subclass = self as? TaskClass {
            subclass.willStart()
        }
    }
    
    final func start(afterTask task: Task, finishesWith states: [State.CompletionState] = []) {
        // (where empty means any state)
    }
    
    final func onProgress(_ handler: ProgressHandler) {
        
    }
    
    final func onCompletion(_ handler: CompletionHandler) {
        
    }
    
    init(withWork workBlock: TaskWorkBlock) {
        super.init()
    }
    
    private override init() {
        super.init()
    }
    
    // autoretry?
}

class MultiTask: Task {
    
    fileprivate var _maxParallelTasks = 0 // (0 == unlimited)
    
    var stopIfAnyFail = false
    
    init(withTasks tasks: [Task]) {
        super.init { (complete) in
            // (figure out how to run tasks together)
        }
    }
}

class SerialTask: MultiTask {
    
    override init(withTasks tasks: [Task]) {
        super.init(withTasks: tasks)
        _maxParallelTasks = 1
    }
}

class ParallelTask: MultiTask {
    
    var maxNumberOfTasks: Int {
        get {
            return _maxParallelTasks
        }
        set {
            _maxParallelTasks = newValue
        }
    }
}







class CustomTask: Task, TaskClass {
    
    internal func doWork() {
        
    }
    
    internal func didFinish() {
        
    }

    internal func willFinish() {
        
    }

    internal func didStart() {
        
    }

    internal func willStart() {
        
    }
    
}


let task = Task() { (complete) in
    complete(.successful)
}
task.start()

let custom = CustomTask()





Task.with(ID:"test")?.onProgress { (percent) in
    
}



