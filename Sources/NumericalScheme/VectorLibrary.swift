//
//  VectorLibrary.swift
//  NumericalScheme
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

import Foundation
import LispKit

///
/// This class implements the NumericalScheme library `(numerical vector)`. This is a
/// demo implementation which just provides functionality for representing flonum vectors
/// of type `f64vector`.
///
public final class VectorLibrary: NativeLibrary {

  /// Initializer of the library; called once per LispKit context.``
  public required init(in context: Context) throws {
    try super.init(in: context)
  }

  /// Name of the library.
  public override class var name: [String] {
    return ["numerical", "vector"]
  }

  /// Dependencies of the library.
  public override func dependencies() {
  }

  /// Declarations of the library.
  public override func declarations() {
    self.define(Procedure("make-f64vector", self.makeF64Vector))
    self.define(Procedure("f64vector", self.f64Vector))
    self.define(Procedure("f64vector?", self.isF64Vector))
    self.define(Procedure("f64vector-length", self.f64VectorLength))
    self.define(Procedure("f64vector-ref", self.f64VectorRef))
    self.define(Procedure("f64vector-set!", self.f64VectorSet))
    self.define(Procedure("f64vector->list", self.f64VectorToList))
    self.define(Procedure("list->f64vector", self.listToF64Vector))
  }

  /// Internal representation of `f64vector` objects
  private final class F64Vector: NativeObject {

    /// Type of `f64vector` objects.
    public static let type: Type = .objectType(Symbol(uninterned: "f64vector"))

    var elements: [Double]

    init(length: Int, expr: Expr?) throws {
      self.elements = [Double](repeating: expr == nil ? 0.0 : try expr!.asDouble(coerce: true),
                               count: length)
      super.init()
    }

    var length: Int {
      return self.elements.count
    }

    func ref(at i: Int) -> Expr {
      return .flonum(self.elements[i])
    }

    func set(at i: Int, to expr: Expr) throws {
      self.elements[i] = try expr.asDouble(coerce: true)
    }

    override var type: Type {
      return F64Vector.type
    }

    override var string: String {
      guard self.length > 0 else {
        return "#<f64vector>"
      }
      var str = ""
      var i = 0
      while i < self.length && i < 1000 {
        str += " \(self.elements[i])"
        i += 1
      }
      return "#<f64vector:\(str)>"
    }

    override var hash: Int {
      return self.elements.hashValue
    }

    override func equals(_ obj: NativeObject) -> Bool {
      guard let vec = obj as? F64Vector else {
        return false
      }
      return self.elements == vec.elements
    }
  }

  /// Convert given expression into a `F64Vector` object if that is possible; throw error
  /// otherwise.
  private func asF64Vector(_ expr: Expr) throws -> F64Vector {
    guard case .object(let obj) = expr, let vec = obj as? F64Vector else {
      throw RuntimeError.type(expr, expected: [F64Vector.type])
    }
    return vec
  }

  private func makeF64Vector(length: Expr, expr: Expr?) throws -> Expr {
    return .object(try F64Vector(length: length.asInt(below: 10000000), expr: expr))
  }

  private func f64Vector(exprs: Arguments) throws -> Expr {
    let res = try F64Vector(length: 0, expr: nil)
    for expr in exprs {
      res.elements.append(try expr.asDouble(coerce: true))
    }
    return .object(res)
  }

  private func isF64Vector(expr: Expr) -> Expr {
    guard case .object(let obj) = expr else {
      return .false
    }
    return .makeBoolean(obj is F64Vector)
  }

  private func f64VectorLength(vec: Expr) throws -> Expr {
    return .makeNumber(try self.asF64Vector(vec).length)
  }

  private func f64VectorRef(vec: Expr, index: Expr) throws -> Expr {
    let v = try self.asF64Vector(vec)
    let i = try index.asInt64()
    guard i >= 0 && i < Int64(v.length) else {
      throw RuntimeError.range(parameter: 2, of: "f64vector-ref", index,
                               min: 0, max: Int64(v.length - 1))
    }
    return v.ref(at: Int(i))
  }

  private func f64VectorSet(vec: Expr, index: Expr, expr: Expr) throws -> Expr {
    let v = try self.asF64Vector(vec)
    let i = try index.asInt64()
    guard i >= 0 && i < Int64(v.length) else {
      throw RuntimeError.range(parameter: 2, of: "f64vector-set", index,
                               min: 0, max: Int64(v.length - 1))
    }
    try v.set(at: Int(i), to: expr)
    return .void
  }

  private func f64VectorToList(vec: Expr) throws -> Expr {
    let v = try self.asF64Vector(vec)
    var res = Expr.null
    for element in v.elements.reversed() {
      res = .pair(.flonum(element), res)
    }
    return res
  }

  private func listToF64Vector(expr: Expr) throws -> Expr {
    let vec = try F64Vector(length: 0, expr: nil)
    var list = expr
    while case .pair(let element, let rest) = list {
      vec.elements.append(try element.asDouble(coerce: true))
      list = rest
    }
    guard case .null = list else {
      throw RuntimeError.type(expr, expected: [.properListType])
    }
    return .object(vec)
  }
}
