/*
 This source file is part of the Swift.org open source project

 Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
 */

import Basics
#if os(macOS)
import class Foundation.Bundle
#endif
import TSCBasic
@_exported import TSCTestSupport
import TSCUtility
import XCTest

public func XCTAssertBuilds(
    _ path: AbsolutePath,
    configurations: Set<Configuration> = [.Debug, .Release],
    extraArgs: [String] = [],
    file: StaticString = #file,
    line: UInt = #line,
    Xcc: [String] = [],
    Xld: [String] = [],
    Xswiftc: [String] = [],
    env: EnvironmentVariables? = nil
) {
    for conf in configurations {
        do {
            _ = try executeSwiftBuild(
                path,
                configuration: conf,
                extraArgs: extraArgs,
                Xcc: Xcc,
                Xld: Xld,
                Xswiftc: Xswiftc,
                env: env
            )
        } catch {
            XCTFail("""
            `swift build -c \(conf)' failed:

            \(error)

            """, file: file, line: line)
        }
    }
}

public func XCTAssertSwiftTest(
    _ path: AbsolutePath,
    file: StaticString = #file,
    line: UInt = #line,
    env: EnvironmentVariables? = nil
) {
    do {
        _ = try SwiftPMProduct.SwiftTest.execute([], packagePath: path, env: env)
    } catch {
        XCTFail("""
        `swift test' failed:

        \(error)

        """, file: file, line: line)
    }
}

public func XCTAssertBuildFails(
    _ path: AbsolutePath,
    file: StaticString = #file,
    line: UInt = #line,
    Xcc: [String] = [],
    Xld: [String] = [],
    Xswiftc: [String] = [],
    env: EnvironmentVariables? = nil
) {
    do {
        _ = try executeSwiftBuild(path, Xcc: Xcc, Xld: Xld, Xswiftc: Xswiftc)

        XCTFail("`swift build' succeeded but should have failed", file: file, line: line)

    } catch SwiftPMProductError.executionFailure(let error, _, _) {
        switch error {
        case ProcessResult.Error.nonZeroExit(let result) where result.exitStatus != .terminated(code: 0):
            break
        default:
            XCTFail("`swift build' failed in an unexpected manner")
        }
    } catch {
        XCTFail("`swift build' failed in an unexpected manner")
    }
}

public func XCTAssertEqual<T: CustomStringConvertible>(
    _ assignment: [(container: T, version: Version)],
    _ expected: [T: Version],
    file: StaticString = #file, line: UInt = #line
)
    where T: Hashable
{
    var actual = [T: Version]()
    for (identifier, binding) in assignment {
        actual[identifier] = binding
    }
    XCTAssertEqual(actual, expected, file: file, line: line)
}
