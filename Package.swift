// swift-tools-version:5.7
//
//  Package.swift
//  NumericalScheme
//  
//  A release can be built with these options:
//  swift build -c release -Xswiftc "-D" -Xswiftc "SPM"
//
//  This creates a release binary in .build/release/ which can be invoked like this:
//  .build/release/NumericalScheme -r .build/checkouts/swift-lispkit/Sources/LispKit/Resources
//  Sources/NumericalScheme/Resources
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
    .macOS(.v13)
  ],
  products: [
    .executable(name: "NumericalScheme", targets: ["NumericalScheme"])
  ],
  dependencies: [
    .package(url: "https://github.com/objecthub/swift-lispkit.git", branch: "master")
  ],
  targets: [
    .executableTarget(name: "NumericalScheme",
                      dependencies: [.product(name: "LispKit", package: "swift-lispkit"),
                                     .product(name: "LispKitTools", package: "swift-lispkit")],
                      exclude: ["Resources"]),
  ],
  swiftLanguageVersions: [.v5]
)
