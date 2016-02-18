---
layout: post
title: "Introduction to Objective-C and iOS Dev"
date: 2013-07-14 11:33
categories:  [ios, development, objective-c]
---

Objective-C is a reflective, compiled, Object-Oriented programming language that adds Smalltalk-Style messaging to C. 
It also tries to do as much as it can dynamically at runtime, rather than at compile time, this allows it to be used in many scenarios - such as its most common use - in applications for Mac OS X and iOS. 
<!-- more -->
To develop for iOS or Mac OS X, you need to have Xcode installed, this can be acquired from the Mac App Store at no cost to yourself, [Xcode (App Store)](https://itunes.apple.com/gb/app/xcode/id497799835?mt=12). 
To debug on a device, or to publish an application on the app store, you also need an iOS developer license.

A standard convention in objective-c is camelCasing of method and variable names and CapsCasing of class names, as opposed to underscore_formatting, adopting this in your code keeps things consistent and readable.


#### Methods

One of the first things you will want to do is call methods, in objective-c, the basic syntax for this is:

    [object method];
    [object methodWithInput:input];

Methods can return objects:

    output = [object methodWithOutput];
    output = [object methodWithInputAndOutput:input];

You can also call methods on classes for example:

    id anObject = [NSURL urlWithString:@"http://iosdev.danie.lt/articles/welcome"];

In Objective-C, the _id_ type means that the _anObject_ variable can refer to any type of object, and its class, methods and properties are not known at compile time. 

In that example, it's clear that the return type will be an _NSURL_, so we can change it to:

    NSURL *myURL = [NSURL urlWithString:@"http://iosdev.danie.lt/articles/welcome"];

Methods can also accept multiple inputs, for example:

    Person *aPerson = [Person personWithFirstName:firstName surname:surname age:age];

#### Variables and Pointers

Nearly all variables in objective-c are objects (other than primitive types such as _int_, _float_ and _double_), more correctly, they are _pointers_ to objects, the * in an objects deceleration is what specifies a pointer type, _id_ is predefined as a pointer, hence its omission, for example:


    id myVariable = [anArray lastObject];
    int x = 42;
    NSNumber *aNumber = [NSNumber numberWithInt:x];

#### Declaring methods

Public methods, are declared in a classes header (classname.h) file, and implemented in the classes implementation (classname.m), although private methods can be written straight into the implementation file.

In Objective-C, class methods are declared in the header like so:

    // The + means class method
    + (NSNumber *)numberWithInt:(int)aInt;

and implemented in the implementation file like so:

    + (NSNumber *)numberWithInt:(int)aInt {
        return [[NSNumber alloc] initWithInt:aInt];
    }

and are often used for convenience initialisers, for example, NSURL (The cocoa class for URLs), has:

    + (NSURL *)URLWithString:(NSString *)stringURL; 

to simplify the allocation and initialisation of NSURLs.

Below you can see three method declarations

    // - means that it is an instance method
    - (void)doSomething;
    - (void)doSomethingWithAString:(NSString *)aString;
    - (void)doSomethingWithAString:(NSString *)aString andInteger:(int)aInt;

These would be implemented like so:

    - (void)doSomething {
        NSLog(@"Hello!");
    }
    
    - (void)doSomethingWithAString:(NSString *)aString {
        NSLog(@"Logging a string! %@", aString);
    }
        
    - (void)doSomethingWithAString:(NSString *)aString andInteger:(int)aInt {
        NSLog(@"Logging a string: %@ and Integer: %d", aString, aInt);
    }

#### Shorthand NSString, NSDictionary, NSArray and NSNumber.

In objective-c, there are shorthand ways to declare strings, dictionaries, arrays and numbers, for example:

    NSString *myString = @"Hello!";
    NSArray *myArray = @[object1, object2, object3];
    NSDictionary *myDict = @{ @"key": anObject, @"anotherKey" : anotherObjectOrValue };
    NSNumber *number = @42;

These are especially useful when used in method calls:

    id anObject = [object objectWithArray:@[values, for, array]];

#### Logging/Debugging

You can also log messages to the console in Xcode, this is extremely useful for debugging, and its NSLog() function is almost identical to the printf() function in C, but has __%@__ for logging objects. 

When you log an object to the console, it calls the __description__ method that returns the string to log.

It is called like so:

    NSLog (@"The value of a string is: %@, the value of a float is: %f, the value of an int is: %d, and the current date and time is: %@", aString, aFloat, aInt, [NSDate date]);

#### Next step

I'd recommend trying out [First iOS App (Apple Developer Docs)](http://developer.apple.com/library/ios/#referencelibrary/GettingStarted/RoadMapiOS/chapters/RM_YourFirstApp_iOS/Articles/01_CreatingProject.html) to get a good basis for how Xcode and how the above things work in practice.

And looking [here](http://cocoadevcentral.com/d/learn_objectivec/) for more refences.