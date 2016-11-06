# Sorbetto

Sorbetto is a (work-in-progress) plugin-based static site generator written in Swift. It was inspired by [Metalsmith][metalsmith].

Sorbetto itself is a tiny application, with all logic handled in plugins. For example, a simple blog could be written as:

```swift
import Sorbetto
import SorbettoMarkdown

SiteBuilder()
    .using(Markdown())
    .build { error, site in

    }
```

To add pagination, just use use another plugin:

```swift
import Sorbetto
import SorbettoMarkdown
import SorbettoPagination

SiteBuilder()
    .using(Markdown())
    .using(Pagination(perPage: 5))
    .build { error, site in

    }
```

## Usage

Basic functionality can be seen above.

The included frontmatter parser is itself a plugin.

## To-Do

The Sorbetto repo itself is almost complete. As the generate is plugin-based,
all "useful" functionality would be contained in separate plugin repositories.
This is [README-driven development][rdd]

The current implementation is almost core-complete, however, we're currently lacking in plugins, and there is no command line tool yet.

## Contributing

Bug reports and pull requests are welcome on GitHub at [sorbetto/sorbetto][repo].

[metalsmith]: https://github.com/metalsmith/metalsmith
[rdd]: http://tom.preston-werner.com/2010/08/23/readme-driven-development.html
[repo]: https://github.com/sorbetto/sorbetto
