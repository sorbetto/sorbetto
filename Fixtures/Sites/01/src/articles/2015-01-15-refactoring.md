---
layout: post
title: "Refactoring"
date: 2015-01-15 09:55
categories: [Code]
---

Brent Simmons [response](http://inessential.com/2015/01/16/daniels_refactoring) to Daniel Jalkut's [refactoring of his network classes](http://indiestack.com/2015/01/same-tests-different-class/) resonated pretty well with me. 
I like to write abstractions on default system API's, but not in the form of subclasses (save for UIKit classes like `UIView`, `UIViewController`), but generally in the form of a plain-old `NSObject` subclass that then uses the system API/Framework. 
This has the advantage of making it easier to compose libraries, and decoupling the implementation from the interface. 

For example, in Brent's example of an RSS Reader I would probably have a `RKTFeedDownloader` that internally could use `NSURLSessionTask`, or NSOperation based `NSURLConnection` with a simple interface that let's you specify feeds to download.
I would then have a `RKTFeedParser` that abstracted away XML Parsing, with internal classes for handling Atom and RSS based feeds.
`RKTFeedController` would then provide a simple API that downloaded a feed and parsed it before calling back with the parsed data. - This allows me to easily decouple the external inteface from the implementation.

Subclassing complex objects tends to make code harder to understand, and you lose control of the details.

The nice thing about programming though, is that we learn and improve over time and develop different styles based upon our experiences.