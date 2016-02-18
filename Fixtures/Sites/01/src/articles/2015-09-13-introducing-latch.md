---
layout: post
title: "Introducing Latch"
date: 2015-09-13 08:30
categories: [OSS, Code, Swift]
---

I've been working on a few Swift projects lately, and I found myself needing a simple wrapper for the keychain API, so I wrote Latch: A Swift 2.x compatible keychain wrapper that runs on iOS, OS X, and watchOS.

It's API is quite simple, you can set and retreive NSData for any given key, and provides convenience setters around String's, and NSCoding-conforming objects.

You can get the source on [GitHub](https://github.com/DanielTomlinson/Latch) or peruse the documentation [here](https://danieltomlinson.github.io/Latch).
