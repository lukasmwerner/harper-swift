# Harper Swift

Swift bindings for the [Harper](https://github.com/Automattic/harper) grammar checker library.

## Overview

This project provides minimal Swift bindings for Harper, a grammar and style checker for English text. It demonstrates how to create a complete Rust -> C -> Swift FFI bridge with proper memory management and error handling.

## Features

- ✅ Document creation
- ✅ Grammar and style linting
- ✅ Suggestion extraction and display
- ✅ Text fragment extraction for problematic areas
- ✅ Complete memory management (automatic cleanup)
- ✅ Command-line interface with example usage

## Quick Start

### Prerequisites

- **Rust** (install via [rustup](https://rustup.rs/))
- **Swift 5.0+** and **Xcode Command Line Tools**
- **macOS 10.15+** (due to platform requirements)

### Installation

```bash
# Clone the repository
git clone https://github.com/lukasmwerner/harper-swift.git
cd harper-swift

# This will build the rust library (for x86_64 and aarch64), then it will make a xcframweork file for the swift build system
./build-and-package.sh

# Build and run the Swift package
swift run harper "Your text here"
```

#### Importing into XCode

Add a new dependency under `File > Add Package Dependencies`. Then press `Add Local` and point to the location of this repo on you local drive.


### Example Usage

```bash
# Basic grammar checking
swift run harper "This sentense have a grammar mistake."

# Check for spelling and style issues
swift run harper "I can't find the .exe for this program."

# Interactive mode (uses default text)
swift run harper
```

**Example Output:**
```
Harper CLI
Version: 0.45.0
Document text: This sentense have a grammar mistake.
Token count: 6
Lint count: 2
Lint 0: Did you mean to spell "sentense" this way? ["sentense"]
  3 suggestion(s):
    1. Replace with: "sentence"
    2. Replace with: "sense"
    3. Replace with: "tense"
Lint 1: Did you mean to spell "have" this way? ["have"]
  1 suggestion(s):
    1. Replace with: "has"
```

## API Reference

### Core Types

#### `Harper.Document`
Represents a text document for analysis.

```swift
// Create a document
let doc = Harper.Document(text: "Your text here")!

// Get document information
let text = doc.getText()           // String?
let tokenCount = doc.getTokenCount() // Int

// Get linting issues
let lints = doc.getLints(lintGroup: lintGroup) // [Lint]
```

#### `Harper.LintGroup`
A collection of linting rules (currently uses curated Australian English rules).

```swift
// Create a lint group
let lintGroup = Harper.LintGroup()!
```

#### `Harper.Lint`
Represents a single grammar or style issue found in the text.

```swift
// Get lint information
let message = lint.message()                    // String?
let (start, end) = lint.startAndEnd()          // (Int64, Int64)
let fragment = lint.textFragment(from: doc)    // String?

// Get suggestions
let count = lint.suggestionCount()              // Int
let suggestion = lint.suggestionText(at: 0)    // String?
```

### Complete Example

```swift
import HarperSwift

// Create a document
let doc = Harper.Document(text: "This sentense have a grammar mistake.")!

// Create a lint group and get lints
let lintGroup = Harper.LintGroup()!
let lints = doc.getLints(lintGroup: lintGroup)

// Process each lint
for (i, lint) in lints.enumerated() {
    print("Issue \(i + 1): \(lint.message() ?? "Unknown issue")")
    
    // Show the problematic text
    if let fragment = lint.textFragment(from: doc) {
        print("  Problematic text: \"\(fragment)\"")
    }
    
    // Show suggestions
    let suggCount = lint.suggestionCount()
    if suggCount > 0 {
        print("  Suggestions:")
        for j in 0..<suggCount {
            if let suggestion = lint.suggestionText(at: j) {
                print("    \(j + 1). \(suggestion)")
            }
        }
    }
    print()
}
```

## Architecture

This project demonstrates a complete Rust -> C -> Swift FFI bridge:

```
┌-----------------┐    ┌--------------┐    ┌-----------------┐
│   Swift API     │<-->│   C FFI      │<-->│   Rust Core     │
│  (HarperSwift)  │    │  (harper.h)  │    │  (harper-core)  │
└-----------------┘    └--------------┘    └-----------------┘
```

### Layer Breakdown

1. **Rust Core** (`src/lib.rs`)
   - Wraps `harper-core` functionality
   - Provides C-compatible FFI functions
   - Handles memory allocation and deallocation

2. **C Interface** (`Sources/CHarper/harper.h`)
   - Declares FFI function signatures
   - Defines opaque types for Rust structs
   - Provides comprehensive documentation

3. **Swift Wrapper** (`Sources/HarperSwift/`)
   - Swift-friendly API design
   - Automatic memory management
   - Proper error handling with optionals

4. **CLI Interface** (`Sources/HarperCLI/`)
   - Demonstrates API usage
   - Provides interactive testing

## Memory Management

The Swift bindings handle all memory management automatically:

- **Documents** are freed when the Swift object is deallocated
- **Lint Groups** are freed when the Swift object is deallocated  
- **Lint Arrays** are freed after use
- **String Messages** are freed after conversion to Swift strings
- **Suggestions** are freed after conversion to Swift strings

No manual memory management is required in Swift code.

## Error Handling

The API uses Swift's optional types for safe error handling:

- Functions that can fail return optionals (`String?`, `Document?`, etc.)
- Functions that return integers return `0` or `-1` on error
- Always check return values before use

## Development

### Project Structure

```
harper-swift/
├-- src/
│   └-- lib.rs              # Rust FFI implementation
├-- Sources/
│   ├-- CHarper/
│   │   └-- harper.h        # C header declarations
│   ├-- HarperSwift/
│   │   └-- Harper.swift    # Swift library implementation
│   └-- HarperCLI/
│       └-- main.swift      # Command-line interface
├-- Package.swift           # Swift package configuration
├-- Cargo.toml             # Rust dependencies
└-- README.md              # This file
```

### Building and Testing

```bash
# Build the Rust library
cargo build --release

# Build and run the Swift package
swift run harper

# Test with specific text
swift run harper "Once upon a timex."

# Run Swift tests
swift test
```

### Adding New Features

1. **Add Rust FFI function** in `src/lib.rs`
2. **Add C header declaration** in `Sources/CHarper/harper.h`
3. **Add Swift wrapper** in `Sources/HarperSwift/Harper.swift`
4. **Update CLI** in `Sources/HarperCLI/main.swift` to demonstrate
5. **Update documentation** in this README

## Comparison with Other FFI Projects

This project follows similar patterns to other Harper FFI bindings:

- **Memory Management**: Automatic cleanup in high-level language
- **Error Handling**: Optionals/nullables for safe error handling
- **API Design**: Idiomatic patterns for each language
- **Documentation**: Comprehensive examples and API reference

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Related Projects

- [Harper](https://github.com/Automattic/harper) - Main Harper repository (contains harper-core)
- [harper-c](https://github.com/hippietrail/harper-c) - Minimal C FFI example bindings for Harper
- [harper-py](https://github.com/hippietrail/harper-py) - Minimal Python FFI example bindings for Harper
- [harper-core](https://crates.io/crates/harper-core) - Core Rust library (available on crates.io)
- [harper-cli](https://github.com/Automattic/harper/tree/master/harper-cli) - Command-line interface
- [harper-ls](https://github.com/Automattic/harper/tree/master/harper-ls) - Language server 
