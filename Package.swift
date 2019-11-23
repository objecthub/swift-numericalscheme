// swift-tools-version:5.1
//
//  Package.swift
//  NumericalScheme
//
//  Build targets by calling the Swift Package Manager in the following way for debug purposes:
//  swift build -Xswiftc "-D" -Xswiftc "SPM"
//
//  Run REPL:
//  swift run -Xswiftc "-D" -Xswiftc "SPM"
//
//  A release can be built with these options:
//  swift build -c release -Xswiftc "-D" -Xswiftc "SPM"
//
//  This creates a release binary in .build/release/. Assumung that a LispKit directory is
//  located in ~/Documents/LispKit, the binary can be invoked like this:
//  .build/release/NumericalScheme -d LispKit
//
//
//  Created by Matthias Zenger on 22/11/2019.
//  Copyright © 2019 Matthias Zenger. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import PackageDescription

let package = Package(
  name: "NumericalScheme",
  platforms: [
    .macOS(.v10_13)
  ],
  products: [
    .executable(name: "NumericalScheme", targets: ["NumericalScheme"])
  ],
  dependencies: [
    .package(url: "https://github.com/objecthub/swift-lispkit.git",
             .upToNextMajor(from: "1.8.2"))
  ],
  targets: [
    .target(name: "NumericalScheme",
            dependencies: ["LispKit", "LispKitTools"],
            exclude: []),
  ],
  swiftLanguageVersions: [.v5]
)
