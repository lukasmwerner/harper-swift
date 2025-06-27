import HarperSwift

@main
struct HarperCLI {
    static func main() {
        print("Harper CLI")
        print("Version: \(Harper.version())")
        print(Harper.hello())
    }
}
