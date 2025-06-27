import CHarper

public struct Harper {
    /// Returns the version of the underlying harper-core library
    public static func version() -> String {
        let versionPtr = harper_version()
        defer { harper_free_string(versionPtr.map { UnsafeMutablePointer(mutating: $0) }) }
        return String(cString: versionPtr!)
    }
    
    public static func hello() -> String {
        return "Hello, World!"
    }
}