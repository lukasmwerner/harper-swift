import HarperSwift

@main
struct HarperCLI {
    static func main() {
        print("Harper CLI")
        print("Version: \(Harper.version())")
        
        let doc = Harper.Document(text: CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "hello,World ! ")!
        let lintGroup = Harper.LintGroup()!
        let lints = doc.getLints(lintGroup: lintGroup)
        
        print("Document text: \(doc.getText() ?? "<nil>")")
        print("Token count: \(doc.getTokenCount())")
        print("Lint count: \(lints.count)")
        
        for (i, lint) in lints.enumerated() {
            let fragment = lint.textFragment(from: doc) ?? "<nil>"
            print("Lint \(i): \(lint.message() ?? "<nil>") [\"\(fragment)\"]")
            
            let suggCount = lint.suggestionCount()
            if suggCount > 0 {
                print("  \(suggCount) suggestion(s):")
                for j in 0..<suggCount {
                    if let suggestion = lint.suggestionText(at: j) {
                        print("    \(j + 1). \(suggestion)")
                    }
                }
            }
        }
    }
}
