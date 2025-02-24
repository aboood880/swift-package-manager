/*
 This source file is part of the Swift.org open source project

 Copyright (c) 2014 - 2021 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

import XCTest

import SPMTestSupport
import Commands

final class TestToolTests: CommandsTestCase {
    
    private func execute(_ args: [String]) throws -> (stdout: String, stderr: String) {
        return try SwiftPMProduct.SwiftTest.execute(args)
    }
    
    func testUsage() throws {
        let stdout = try execute(["-help"]).stdout
        XCTAssert(stdout.contains("USAGE: swift test"), "got stdout:\n" + stdout)
    }

    func testSeeAlso() throws {
        let stdout = try execute(["--help"]).stdout
        XCTAssert(stdout.contains("SEE ALSO: swift build, swift run, swift package"), "got stdout:\n" + stdout)
    }

    func testVersion() throws {
        let stdout = try execute(["--version"]).stdout
        XCTAssert(stdout.contains("Swift Package Manager"), "got stdout:\n" + stdout)
    }

    func testNumWorkersParallelRequirement() throws {
        // Running swift-test fixtures on linux is not yet possible.
        #if os(macOS)
        fixture(name: "Miscellaneous/EchoExecutable") { path in
            do {
                _ = try execute(["--num-workers", "1"])
            } catch SwiftPMProductError.executionFailure(_, _, let stderr) {
                XCTAssertMatch(stderr, .contains("error: --num-workers must be used with --parallel"))
            }
        }
        #endif
    }
    
    func testNumWorkersValue() throws {
        #if os(macOS)
        fixture(name: "Miscellaneous/EchoExecutable") { path in
            do {
                _ = try execute(["--parallel", "--num-workers", "0"])
            } catch SwiftPMProductError.executionFailure(_, _, let stderr) {
                XCTAssertMatch(stderr, .contains("error: '--num-workers' must be greater than zero"))
            }
        }
        #endif
    }
}
