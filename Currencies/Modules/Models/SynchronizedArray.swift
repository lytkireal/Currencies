//
//  SynchronizedArray.swift
//  Currencies
//
//  Created by Artem Lytkin on 05/06/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import Foundation

class SynchronizedArray<T> {
    
    weak var delegate: SynchronizedArrayDelegate?
    private let queue = DispatchQueue(label: "com.lytkinreal.currencies.pairs_list_service_array_queue", attributes: .concurrent)
    private var array: [T] = [] {
        didSet {
            delegate?.arrayChanged(isEmpty: array.isEmpty)
        }
    }
    
    public var isEmpty: Bool {
        var isEmpty = true
        queue.sync {
            isEmpty = self.array.isEmpty
        }
        return isEmpty
    }
    
    
    public var count: Int {
        var count = 0
        queue.sync {
            count = self.array.count
        }
        return count
    }
    
    public var allValues: [T] {
        var values: [T] = []
        queue.sync {
            values = self.array
        }
        return values
    }
    
    public func append(_ newElement: T) {
        queue.async(flags: .barrier) {
            self.array.append(newElement)
        }
    }
    
    public func append(contentsOf sequence: [T]) {
        queue.async(flags: .barrier) {
            self.array.append(contentsOf: sequence)
        }
    }
    
    public func remove(at index: Int) -> T {
        var element: T!
        
        queue.sync {
            element = self.array.remove(at: index)
        }
        
        return element
    }
    
    public func first() -> T? {
        var element: T?
        
        self.queue.sync {
            element = self.array.first
        }
        
        return element
    }
    
    public func map<S>(_ transform: (T) -> S) -> [S] {
        let result = self.array.map { (element) -> S in
            transform(element)
        }
        
        return result
    }
    
    public func enumerated() -> EnumeratedSequence<[T]> {
        var enumeratedSequence: EnumeratedSequence<[T]>!
        
        queue.sync {
            enumeratedSequence = self.array.enumerated()
        }
        
        return enumeratedSequence
    }
    
    subscript(index: Int) -> T {
        set {
            queue.async(flags: .barrier) {
                self.array[index] = newValue
            }
        }
        get {
            var element: T!
            
            queue.sync {
                element = array[index]
            }
            
            return element
        }
    }
}
