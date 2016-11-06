import PathKit

extension Path {
    func absolutePath(relativeTo directory: Path) -> Path {
        assert(directory.isAbsolute)
        if isAbsolute {
            return self
        } else {
            return (directory + self).absolute()
        }
    }

    func relativePath(from directory: Path) -> Path {
        assert(directory.isAbsolute)
        guard isAbsolute else {
            return self
        }

        let components = self.components
        let index: Int = {
            let directoryComponents = directory.components
            for (i, (c1, c2)) in zip(components, directoryComponents).enumerated() {
                if c1 != c2 {
                    return i
                }
            }

            return Swift.min(directoryComponents.count, components.count)
        }()
        
        return Path(components: components[index ..< components.endIndex])
    }
}
