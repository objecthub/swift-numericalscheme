//
//  main.swift
//  NumericalScheme
//
//  Created by Matthias Zenger on 22/10/2019.
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

import Foundation
import LispKit

let name = "NumericalScheme"
let version = "1.0"
let copyright = "Copyright © 2019 Matthias Zenger"
let features = ["repl", "numerical-scheme"]
#if SPM
let internalResources = false
#else
let internalResources = true
#endif

// Static configuration of the the LispKit framework.
Context.simplifiedDescriptions = true
LibraryRegistry.register(VectorLibrary.self)

// Creation of LispKit read-eval-print loop.
let repl = NumericalSchemeRepl(name: name, version: version, build: "",
                               copyright: copyright, prompt: "> ")

// Parse and check command line arguments.
guard repl.flagsValid() else {
  exit(1)
}

// Invoke read-eval-print loop if requested.
if repl.shouldRunRepl() {
  guard repl.configurationSuccessfull(implementationName: name,
                                      implementationVersion: version,
                                      includeInternalResources: internalResources,
                                      defaultDocDirectory: "NumericalScheme",
                                      features: features),
        repl.run() else {
    exit(1)
  }
}

// Regular exit of read-eval-print loop
exit(0)
