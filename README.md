# Sorbetto

Sorbetto is a work in progress plugin based static site generator built in Swift.

Sorbetto itself is a tiny application, with all the logic handled in plugins. 
For example, a simple blog may be:

```swift
import Sorbetto
import SorbettoMarkdown

try! Sorbetto()
  .parsesFrontmatter(true)
  .using(markdown())
  .build(clean: true)
```

but if you wanted to add pagination, you could add a plugin:

```swift
import Sorbetto
import SorbettoMarkdown
import SorbettoPagination

try! Sorbetto()
  .parsesFrontmatter(true)
  .using(markdown())
  .using(paginate(5))
  .build(clean: true)
``` 

## Todo

The current implementation is almost core-complete, however, we're currently
lacking in plugins, and there is no command line tool yet.
