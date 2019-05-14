//
//  AsyncOperation.swift
//  Guardioes
//
//  Created by Bruno Lopes de Mello on 21/03/19.
//  Copyright © 2019 Bruno Lopes de Mello. All rights reserved.
//

import Foundation

class AsyncOperation {
    
    typealias NumberOfPendingActions = Int
    typealias DispatchQueueOfReturningValue = DispatchQueue
    typealias CompleteClosure = ()->()
    
    private let dispatchQueue: DispatchQueue
    private var semaphore: DispatchSemaphore
    
    private var numberOfPendingActionsQueue: DispatchQueue
    public private(set) var numberOfPendingActions = 0
    
    var whenCompleteAll: (()->())?
    
    init(numberOfSimultaneousActions: Int, dispatchQueueLabel: String) {
        dispatchQueue = DispatchQueue(label: dispatchQueueLabel)
        semaphore = DispatchSemaphore(value: numberOfSimultaneousActions)
        numberOfPendingActionsQueue = DispatchQueue(label: dispatchQueueLabel + "_numberOfPendingActionsQueue")
    }
    
    func run(closure: @escaping (@escaping CompleteClosure)->()) {
        
        self.numberOfPendingActionsQueue.sync {
            self.numberOfPendingActions += 1
        }
        
        dispatchQueue.async {
            self.semaphore.wait()
            closure {
                self.numberOfPendingActionsQueue.sync {
                    self.numberOfPendingActions -= 1
                    if self.numberOfPendingActions == 0 {
                        self.whenCompleteAll?()
                    }
                }
                self.semaphore.signal()
            }
        }
    }
}
