import PathKit

#if os(Linux)
import Glibc
#else
import Darwin
#endif

extension Path {
  var fileMode: Int? {
    return String(self).withCString { buffer in
      var fileStat = stat()
      if stat(buffer, &fileStat) == 0 {
        return Int(fileStat.st_mode)
      } else {
        return nil
      }
    }
  }
}
