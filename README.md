# Swift NumericalScheme

This Xcode project showcases how to extend [Swift LispKit](https://github.com/objecthub/swift-lispkit).
The project implements a read-eval-print loop for an extended LispKit language supporting native
flonum vectors and arrays.

Here is how to build and invoke a release binary:

```
git clone https://github.com/objecthub/swift-numericalscheme
cd swift-numericalscheme
carthage bootstrap --platform macOS
swift build -c release -Xswiftc "-D" -Xswiftc "SPM"
.build/release/NumericalScheme -r .build/checkouts/swift-lispkit/Sources/LispKit/Resources Sources/NumericalScheme/Resources
```

Alternatively, _Xcode_ can be used to build and execute the command-line tool.

