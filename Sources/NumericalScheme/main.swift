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
let copyright = "Copyright © 2019-2024 Matthias Zenger"

// Static configuration of the the LispKit framework.
Context.simplifiedDescriptions = true
LibraryRegistry.register(VectorLibrary.self)

// Creation of LispKit read-eval-print loop.
let repl = NumericalSchemeRepl(name: name,
                               version: version,
                               build: "",
                               copyright: copyright, prompt: "> ")

// Parse and check command line arguments.
guard repl.flagsValid() else {
  exit(1)
}

// Invoke read-eval-print loop if requested.
if repl.shouldRunRepl() {
  var features = ["repl", "numerical-scheme"]
  if repl.runloop.wasSet {
    features.append("runloop")
  }
  if LispKitContext.bundle == nil {
    guard repl.configurationSuccessfull(implementationName: name,
                                        implementationVersion: version,
                                        includeInternalResources: false,
                                        defaultDocDirectory: "NumericalScheme",
                                        features: features) else {
      exit(1)
    }
  } else {
    guard repl.configurationSuccessfull(features: features) else {
      exit(1)
    }
  }
  if repl.runloop.wasSet {
    repl.toolMessage = "[enabled run loop]"
    let main = Thread {
      let succeeded = repl.run()
      repl.release()
      exit(succeeded ? 0 : 1)
    }
    main.stackSize = (repl.systemStackSize.value ?? (12 * 1024)) * 1024
    main.qualityOfService = .userInitiated
    main.start()
    RunLoop.current.run()
  } else {
    let succeeded = repl.run()
    repl.release()
    exit(succeeded ? 0 : 1)
  }
}
