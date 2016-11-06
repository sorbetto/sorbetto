import PathKit

extension Path {
    func absolute(relativeTo directory: Path) -> Path {
        assert(directory.isAbsolute)
        if isAbsolute {
            return self
        } else {
            return (directory + self).absolute()
        }
    }

    func relative(from directory: Path) -> Path {
        guard isAbsolute else {
            return self
        }

        let components = self.components
        let index: Int = {
            let directoryComponents = directory.absolute().components
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
