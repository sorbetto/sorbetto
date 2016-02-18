---
layout: post
title: "How Objective-C messaging works"
date: 2013-08-03 23:47
categories: [ios, development, objective-c]
---

I have always been interested in how the low level of programming languages work, and lots a fair few people on IRC and Twitter have asked how messaging in objective-c works, so I've decided to blog about it!
<!-- more -->
To understand how messaging in objective-c works, we first need to understand how its objects are represented in memory.

To understand what an object really is, we need to go to the lowest-level of the object - its representation in memory, and to understand the Objective-C memory model, you must first understand that of C.

So, how is a C object represented in memory?

    int i;

would possibly look like this:

    i = 0xDEADBEEF

    [DE] [AD] [BE] [EF]

in C on a 32-bit machine, however, this is Big-Endian, on an intel mac, it would look like this (as intel macs are little-endian):

    [EF] [BE] [AD] [DE]

However, in this post, we'll use big-endian, as it is easier to read.

The C Struc for a single int, looks something like this:


    typedef struct _IntContainer {
      int i;
    } IntContainer;
    
    InctContainer ic;
    
    ic.i = 0xDEADBEEF;


this is important, as in terms of memory layout, a struct with a single int, is identical to int, and therefore you can cast between IntContainer and an int for a value without and precision lost. In cocoa, a CFType also has an identical memory layout as NSObject 0 this is how it provides Toll-Free bridging.

But how would something with more than one field look? Well, its just contiguous objects in memory, with some extra things for alignment and padding. For example:



    typedef struct _NSPoint {
      CGFloat x;
      CGFloat y;
    }
    
    NSPoint p;
    p.x = 1.0;
    p.y = 2.0;
    
    
    //Memory
    //[3f][80][00][00] [40][00][00][00]



A pointer (class \*), point to another location of memory, for example:

    int* pointer;
    *pointer = 0xreadbook;
    
    //Memory
    pointer:05010203  0x05010203:readbook


The * _dereferences_ the pointer, and sets the value at the pointed to address, sort of like forwading the message.


### Moving on to Objective\-C ###

So, now we're ready to look at the memory structure of objective\-c, it looks something like this:

    struct NSObject {
      Class isa;
    }

(declaring an @interface is a fancy way of declaring a struct of the same name, and tells the compiler its an objective c class).

isa is just something that points to a class. But what is class? 
Well, it's something that is defined in: 

    <objc/objc.h>

as a typedef for objc_class\*, so NSObject is a single pointer to a class definition.

objc_class, looks something like this:

    struct objc_class {
      Class isa;
      Class super_class;
      const char *name;
      long version;
      long info;
      long instance_size;
      struct objc_ivar_list *ivars;
      struct objc_method_lists **methodLists;
      struct objc_cache *cache;
      struct objc_protocol_list *protocols;
    }

objc\_class has an isa of Class type, and it is the same as that of NSObject, so an objc\_class is an object, because its memory model is the same, and things like message sending that work on instance objects, also work on objects, reducing the amount of special case code needed to distinguish between the two. It's _isa_ field however, points to a _metaclass_ object, which is just another objc\_class struct. Every class definition therefore has a class and metaclass definition, this is because a class objects list of methods are for _instances_ of the class, and the metaclass objects list of methods are for _class_ methods.

A metaclass' isa pointer however, simply terminates the cycle by pointing to itself (We don't have metaclass methods yet!).


### Messaging ###

When we start learning objective-c, we are (mostly) taught that our magical brackety code

    [self doSomethingTo:var1];

is transformed into something like:

    objc_msgSend(self, @selector(doSomethingTo:), var1);

and expected to just accept that it works, until we begin to advance, and start understanding what the runtime is doing to our code.

The objective c runtime is written mainly in C and ASM to add all the amazing object orientated capabilities to C, creating Objecitve-C, this means it handles classes, method dispatch, method forwarding etc, and all the support structures that make it possible.

So, here is some basic runtime terminology and more structs!

A selector in Objective-C is a struct that identifies an Objective-C method you want an object to perform, and defined:

    typedef struct objc_selector *SEL

and used like:

    SEL select = @selector(doSomething)


So, what is a message? An Objective-C message is everything between the two brackets \[\], and consists of the target, the method and any arguments. An Objective-C method, whilst similar to methods in C, is different, the fact that you are sending a message to an object, does not mean that it'll perform it, the object could dynamically decide based on runtime variables such as the sender, to perform a different method, or forward to a different object.

    [target thisIsTheMethod:arg1];

Its decleration would be converted into something like so:

    void -[target thisIsTheMethod:](id self, SEL _cmd, NSString* aString)

The only thing different to your objective-c code is that it adds two extra arguments - self and \_cmd, and some characters that are usually dissalowed in c (\[\]-), and if you get hold of a function pointer - you can actually call it in your code (although it isn't recommended).

It would then be called like so:

    objc_msgSend(target, @selector(thisIsTheMethod:), @” (YOLO)”);

Now, what happens when you use the [...] syntax to send a message to an object? The compiler actually transforms that into a call to a function named objc_msgSend() that’s part of the Objective-C runtime. objc_msgSend() takes at least two arguments: the object to send the message to (receiver in Objective-C lingo), and something called a selector, which is simply jargon for "“"a method name".

A selector is simply a C string, well, not quite, it has the same memory structure - NUL-terminated char \* pointer - however the objective-c compiler ensures there is only one instance of the selector in the entire address space.

### Building objc_msgSend ###

You may be interested in seeing how an implementation of objc_msgSend would look, so here goes. In C, the function would look something like this:

    id objc_msgSend(id receiver, SEL name, arguments...) {
      IMP function = class_getMethodImplementation(receiver->isa, name);
      return function(arguments);
    }

Although, due to the millions of times a second that this can potentially be called, it would be implemented in meticulously tuned ASM, because it needs to be incredibly fast. 

The method class_getMethodImplementation() that, when given a class object and a selector, returns the IMP, a C function implementation for that method. It does this by looking up the class’s method list and returns the IMP that matches the selector. Now that you have an IMP, (the IMP is a C Function pointer), you can call it just like you would any other C function. So, all objc_msgSend() does is grab the receiver’s class object via the isa field, finds the IMP for the selector, and thats it. We have message sending.

If you want to read more about objc_msgSend, I'd recommend looking [here](http://www.mikeash.com/pyblog/friday-qa-2012-11-16-lets-build-objc_msgsend.html) [and here](http://developer.apple.com/library/ios/#DOCUMENTATION/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtHowMessagingWorks.html)

I hope you enjoyed this post, if you did, please leave a comment down below, or share it on FaceBook/Twitter/HackerNews, it's much appreciated :)

