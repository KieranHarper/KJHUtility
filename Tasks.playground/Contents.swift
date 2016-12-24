//: Playground - noun: a place where people can play

import UIKit

public class Taskii: NSObject {
    
    
    // MARK: - Types
    
    public enum State {
        
        // Running cases
        case notStarted, running, cancelling
        
        // Finished cases
        case successful, cancelled, failed
    }
    
    public typealias FinishHandler = (_ state: State)->()
    public typealias ProgressHandler = (_ percent: Float)->()
    public typealias TaskFinishBlock = (_ state: State)->()
    public typealias TaskWorkBlock = (_ progress: ProgressHandler, _ finish: TaskFinishBlock)->()
    
    
    
    // MARK: - Properties
    
    public private(set) var identifier = UUID().uuidString
    public lazy var queueForWork: DispatchQueue = DispatchQueue(label: "TaskWork", attributes: .concurrent)
    public var queueForFeedback = DispatchQueue.main
    
    private var _internalQueue: DispatchQueue!
    private var _currentState = State.notStarted
    private var _workToDo: TaskWorkBlock?
    private var _startHandler: (()->())?
    private var _progressHandler: ProgressHandler?
    private var _finishHandler: FinishHandler?
    
    static var _cachedTasks = Dictionary<String, Taskii>()
    
    
    
    // MARK: - Lifecycle
    
    public override init() {
        super.init()
        setupTask(workBlock: nil)
    }
    
    public final class func with(ID identifier: String) -> Taskii? {
        return _cachedTasks[identifier]
    }
    
    public init(withWork workBlock: @escaping TaskWorkBlock) {
        super.init()
        setupTask(workBlock: workBlock)
    }
    
    private func setupTask(workBlock: TaskWorkBlock?) {
        _internalQueue = DispatchQueue(label: "TaskInternal")
        _workToDo = workBlock
    }
    
    
    
    // MARK: - Control
    
    public final func start(finishHandler: FinishHandler? = nil) {
        
        // Get on the safe queue to change our state and get started via helper
        _internalQueue.async {
            self.doStart()
        }
    }
    
    public final func start(afterTask task: Taskii, finishesWith allowedOutcomes: [State] = [], finishHandler: FinishHandler? = nil) {
        
        // (where empty means any state)
        
        // Just attach to the dependent task's finish
        task.onFinish { (outcome) in
            
            // Start us if the state falls within one of our options
            if allowedOutcomes.isEmpty || allowedOutcomes.contains(outcome) {
                self.start(finishHandler: finishHandler)
            }
            
            // Otherwise finish by passing on the dependent's outcome
            else {
                self.finish(withFinalState: outcome)
            }
        }
    }
    
    public final func cancel() {
        _internalQueue.async { [weak self] in
            self?._currentState = .cancelling
        }
    }
    
    
    
    // MARK: - Feedback
    
    public final func onStart(_ handler: @escaping ()->()) {
        _internalQueue.async { [weak self] in
            self?._startHandler = handler
        }
    }
    
    public final func onProgress(_ handler: @escaping ProgressHandler) {
        _internalQueue.async { [weak self] in
            self?._progressHandler = handler
        }
    }
    
    public final func onFinish(_ handler: @escaping FinishHandler) {
        _internalQueue.async { [weak self] in
            self?._finishHandler = handler
        }
    }
    
    
    
    // MARK: - Private (ON INTERNAL)
    
    private func doStart() {
        
        // Retain ourself and cache for retrieval later
        Taskii._cachedTasks[identifier] = self
        
        // Ensure we actually have work to do, fail otherwise
        guard let work = _workToDo else {
            finish(withFinalState: .failed)
            return
        }
        
        // Change the state to running just before we do anything
        self._currentState = .running
        
        // Actually start the work on the worker queue
        self.queueForWork.sync {
            work({ (percent) in
                if let handler = self._progressHandler {
                    self.queueForFeedback.async {
                        handler(percent)
                    }
                }
            }, { (outcome) in
                self.finish(withFinalState: outcome)
            })
        }
        
        // If needed, provide feedback about the fact we've started
        if let feedback = self._startHandler {
            queueForFeedback.async {
                feedback()
            }
        }
    }
    
    private func doFinish(withFinalState state: State) {
        
        // Change the state
        self._currentState = state
        
        // Now get on the feedback queue to finish up
        self.queueForFeedback.sync {
            self._finishHandler?(self._currentState)
        }
        
        // Remove ourself from the cache / stop retaining self
        Taskii._cachedTasks[identifier] = nil
    }
    
    
    
    // MARK: - Private (ON ANY)
    
    private func finish(withFinalState state: State) {
        
        // Get on the safe queue and change the state
        _internalQueue.async {
            self.doFinish(withFinalState: state)
        }
    }
    
    // TODO: Add autoretry capabilities
}

public class MultiTaskii: Taskii {
    
    fileprivate var _maxParallelTasks = 0 // (0 == unlimited)
    
    public var stopIfAnyFail = false
    
    public init(withTasks tasks: [Taskii]) {
        super.init { (finish) in
            // (figure out how to run tasks together)
        }
    }
}

public class SerialTaskii: MultiTaskii {
    
    public override init(withTasks tasks: [Taskii]) {
        super.init(withTasks: tasks)
        _maxParallelTasks = 1
    }
}

public class ParallelTaskii: MultiTaskii {
    
    public var maxNumberOfTasks: Int {
        get {
            return _maxParallelTasks
        }
        set {
            _maxParallelTasks = newValue
        }
    }
}







class MyCustomTask: Taskii {
    
    override init() {
        super.init { (finish) in
            
            // custom work stuff here
        }
        
        // add feedback handlers to self if desired
    }
    
}







let task = Taskii() { (progress, finish) in
    finish(.successful)
}
task.start()
task.start { (outcome) in
    
}
task.onFinish { (outcome) in
    // executed eventually
}

let custom = MyCustomTask()

let t = Taskii { (finish) in
    
}

Taskii.with(ID:"test")?.onProgress { (percent) in
    
}



