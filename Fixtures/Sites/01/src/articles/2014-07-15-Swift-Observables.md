---
layout: post
title: "Observables in Swift"
date: 2014-07-15 00:14
categories: [Code, Swift]
url: test
---

As you may know, in Swift you cannot perform typical Key-Value Observing on non-NSObject subclasses. Whilst this may be an annoyance for people who make use of KVO on a regular basis, it isn't necessarily a bad thing, KVO is hard and lots of people get it wrong.

Type generic classes and structs in Swift make it pretty trivial to create our own simplistic implementation of Observables, and we get the added benefit of them being opt-in and self documenting. I put a simple example of Observables together here: [Gist](https://gist.github.com/DanielTomlinson/c250f4ce99a2bbb647cb).

    struct Observable<T> {
        
        typealias Observer = (send:(newValue: T) -> ())
        
        var observers = Dictionary<String, Observer>()
        
        var value: T {
            didSet {
                _notify()
            }
        }
        
        /**
        *  Create a new Observable with a stored value
        */
        init(_ value: T) {
            self.value = value
        }
        
        /**
        *  Get the value stored instide the `Observable`.
        *
        *  @return The value stored inside the observer.
        */
        func get() -> T {
            return value
        }
        
        /**
        *  Update the stored value of the `Observable` and notify the observers.
        *
        *  @param value A new value of type T
        */
        mutating func set(value: T) {
            self.value = value
        }
     
        /**
        *  Add an observer with a random identifier
        *
        *  @param observer A closure that takes a paramater of type T
        *
        *  @return The identifier of the observer
        */
        mutating func addObserver(observer: Observer) -> String {
            var identifier = _randomIdentifier()
            addObserver(identifier, observer: observer)
            
            return identifier
        }
        
        /**
        *  Add an observer with a given identifier
        *
        *  @param identifier The identifier to register an observer for
        *  @param observer A closure that takes a paramater of type T
        */
        mutating func addObserver(identifier: String, observer: Observer) {
            observers[identifier] = observer
        }
        
        /**
        *  Remove an Observer with a given identifier
        *
        *  @param identifier the Observer to remove an identifier for
        */
        mutating func removeObserver(identifer: String) {
            observers.removeValueForKey(identifer)
        }
        
        // Private
        
        func _notify() {
            for (identifier, observer) in observers {
                observer.send(newValue: value)
            }
        }
        
        func _randomIdentifier() -> String {
            var tempString = ""
            for index in (0 ..< 30) {
                tempString += String(arc4random_uniform(10))
            }
            
            return tempString
        }
    }

It has lots of room for improvement, for example: storing Observers inside a Bag to prevent naming collisions, using an underlying event or stream system, and custom operators for adding observers/mutating its value - but it's a nice, safer replacement for KVO.


Let me know what you thing on [Twitter](http://twitter.com/DanToml) or in the Gist comments.