# Swift NumericalScheme

[![Platform: macOS](https://img.shields.io/badge/Platform-macOS-blue.svg?style=flat)](https://developer.apple.com/osx/)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux-blue.svg?style=flat)](https://www.ubuntu.com/)
[![Language: Swift 5.1](https://img.shields.io/badge/Language-Swift%205.1-green.svg?style=flat)](https://developer.apple.com/swift/)
[![IDE: Xcode 11.2](https://img.shields.io/badge/IDE-Xcode%2011.2-orange.svg?style=flat)](https://developer.apple.com/xcode/)
[![Carthage: compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License: Apache 2.0](https://img.shields.io/badge/License-BSD-lightgrey.svg?style=flat)](https://developers.google.com/open-source/licenses/bsd)

This Xcode project showcases how to extend [Swift LispKit](https://github.com/objecthub/swift-lispkit).
The project implements a read-eval-print loop for an extended LispKit language supporting native
flonum vectors and arrays. The flonum vectors are implemented in terms of a new native LispKit library
[`(numerical vector)`](https://github.com/objecthub/swift-numericalscheme/blob/master/Sources/NumericalScheme/VectorLibrary.swift), the flonum array library is implemented as a regular Scheme library
[`(numerical array)`](https://github.com/objecthub/swift-numericalscheme/blob/master/Sources/NumericalScheme/Resources/Libraries/numerical/array.sld) and uses the flonum vector library in its implementation.

## Building the tool

### Xcode

```
git clone https://github.com/objecthub/swift-numericalscheme
cd swift-numericalscheme
carthage bootstrap --platform macOS
open NumericalScheme.xcodeproj
```

The NumericalScheme command-line tool is built via the scheme `NumericalScheme` of the Xcode project and
can be executed directly in Xcode. For running the tool in a terminal, using the Swift Package Manager is the
preferred approach.

### Swift Package Manager

```
git clone https://github.com/objecthub/swift-numericalscheme
cd swift-numericalscheme
swift build -c release -Xswiftc "-D" -Xswiftc "SPM"
```

This will statically link all libraries into one binary `.build/release/NumericalScheme`. For executing the
binary, the tool needs access to the supplemental files coming with LispKit as well as with _NumericalScheme_
itself. These are typically provided via the `-r` (i.e. `--roots`) command-line argument. The order of the
directory paths matter; i.e. the second path is searched before the first path, so by specifying the _NumericalScheme_
path first, it will be possible to override definitions/libraries provided by the _LispKit_ framework.

This is how the _NumericalScheme_ command-line tool can be invoked (assuming the current directory is the
root directoy `swift-numericalscheme`):

```
.build/release/NumericalScheme -r .build/checkouts/swift-lispkit/Sources/LispKit/Resources Sources/NumericalScheme/Resources
```

## Testing the tool

After starting up the tool, enter the following command in the read-eval-print loop:

```
(load "Examples/Matrix")
```

This will load and execute the test program [Matrix.scm](https://github.com/objecthub/swift-numericalscheme/blob/master/Sources/NumericalScheme/Resources/Examples/Matrix.scm). If executing the command will results in the output below, everything is set up correctly:

```
#f64array:(#<f64vector: 1.0 6.0 11.0 2.0 7.0 12.0 3.0 8.0 13.0 4.0 9.0 14.0 5.0 10.0 15.0> 3 5)
```

## Requirements

The following technologies and components are needed to build the _NumericalScheme_ command-line
tool:

- [Swift 5.1](https://developer.apple.com/swift/)
- [Xcode 11.2](https://developer.apple.com/xcode/)
- [Swift Package Manager](https://swift.org/package-manager/)
- [LispKit](http://github.com/objecthub/swift-lispkit)
