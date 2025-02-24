Note: This is in reverse chronological order, so newer entries are added to the top.

Swift 5.6
-----------
* [SE-0332]

  Package plugins of the type `command` can now be declared in packages that specify a tools version of 5.6 or later, and can be invoked using the `swift package` subcommand.

* [#3649]

  Semantic version dependencies can now be resolved against Git tag names that contain only major and minor version identifiers.  A tag with the form `X.Y` will be treated as `X.Y.0`. This improves compatibility with existing repositories.

* [#3486]

  Both parsing and comparison of semantic versions now strictly follow the [Semantic Versioning 2.0.0 specification](https://semver.org). 
  
  The parsing logic now treats the first "-" in a version string as the delimiter between the version core and the pre-release identifiers, _only_ if there is no preceding "+". Otherwise, it's treated as part of a build metadata identifier.
  
  The comparison logic now ignores build metadata identifiers, and treats 2 semantic versions as equal if and only if they're equal in their major, minor, patch versions and pre-release identifiers.

* [#3641]

  Soft deprecate `.package(name:, url:)` dependency syntax in favor of `.package(url:)`, given that an explicit `name` attribute is no longer needed for target dependencies lookup.

* [#3641]

  Adding a dependency requirement can now be done with the convenience initializer `.package(url: String, exact: Version)`.

Swift 5.5
-----------
* [#3410]

  In a package that specifies a minimum tools version of 5.5, `@main` can now be used in a single-source file executable as long as the name of the source file isn't `main.swift`.  To work around special compiler semantics with single-file modules, SwiftPM now passes `-parse-as-library` when compiling an executable module that contains a single Swift source file whose name is not `main.swift`.

* [#3310]

  Adding a dependency requirement can now be done with the convenience initializer `.package(url: String, revision: String)`.

* [#3292]

  Adding a dependency requirement can now be done with the convenience initializer `.package(url: String, branch: String)`.

* [#3280]

  A more intuitive `.product(name:, package:)` target dependency syntax is now accepted, where `package` is the package identifier as defined by the package URL.

* [#3316]

  Test targets can now link against executable targets as if they were libraries, so that they can test any data structures or algorithms in them.  All the code in the executable except for the main entry point itself is available to the unit test.  Separate executables are still linked, and can be tested as a subprocess in the same way as before.  This feature is available to tests defined in packages that have a tools version of `5.5` or newer. 

Swift 5.4
-----------
* [#2937]
  
  * Improvements
    
    `Package` manifests can now have any combination of leading whitespace characters. This allows more flexibility in formatting the manifests.
    
    [SR-13566] The Swift tools version specification in each manifest file now accepts any combination of _horizontal_ whitespace characters surrounding `swift-tools-version`, if and only if the specified version ≥ `5.4`. For example, `//swift-tools-version:	5.4` and `//		 swift-tools-version: 5.4` are valid.
  
    All [Unicode line terminators](https://www.unicode.org/reports/tr14/) are now recognized in `Package` manifests. This ensures correctness in parsing manifests that are edited and/or built on many non-Unix-like platforms that use ASCII or Unicode encodings. 
  
  * API Removal
  
    `ToolsVersionLoader.Error.malformedToolsVersion(specifier: String, currentToolsVersion: ToolsVersion)` is replaced by `ToolsVersionLoader.Error.malformedToolsVersionSpecification(_ malformation: ToolsVersionSpecificationMalformation)`.
    
    `ToolsVersionLoader.split(_ bytes: ByteString) -> (versionSpecifier: String?, rest: [UInt8])` and `ToolsVersionLoader.regex` are together replaced by `ToolsVersionLoader.split(_ manifest: String) -> ManifestComponents`.
  
  * Source Breakages for Swift Packages
    
    The package manager now throws an error if a manifest file contains invalid UTF-8 byte sequences.
    


Swift 4.2
---------

* [SE-0209]

  The `swiftLanguageVersions` property no longer takes its Swift language versions via
  a freeform Integer array; instead it should be passed as a new `SwiftVersion` enum
  array.

* [SE-0208]

  The `Package` manifest now accepts a new type of target, `systemLibrary`. This
  deprecates "system-module packages" which are now to be included in the packages
  that require system-installed dependencies.

* [SE-0201]

  Packages can now specify a dependency as `package(path: String)` to point to a
  path on the local filesystem which hosts a package. This will enable interconnected
  projects to be edited in parallel.

* [#1604]

  The `generate-xcodeproj` has a new `--watch` option to automatically regenerate the Xcode project
  if changes are detected. This uses the
  [`watchman`](https://facebook.github.io/watchman/docs/install.html) tool to detect filesystem
  changes.

* Scheme generation has been improved:
  * One scheme containing all regular and test targets of the root package.
  * One scheme per executable target containing the test targets whose dependencies
    intersect with the dependencies of the exectuable target.

* [SR-6978]
  Packages which mix versions of the form `vX.X.X` with `Y.Y.Y` will now be parsed and
  ordered numerically.

* [#1489]
  A simpler progress bar is now generated for "dumb" terminals.

Swift 4.1
---------

* [#1485]
  Support has been added to automatically generate the `LinuxMain` files for testing on
  Linux systems. On a macOS system, run `swift test --generate-linuxmain`.

* [SR-5918]
  `Package` manifests that include multiple products with the same name will now throw an
  error.


Swift 4.0
---------

* The generated Xcode project creates a dummy target which provides
  autocompletion for the manifest files. The name of the dummy target is in
  format: `<PackageName>PackageDescription`.

* `--specifier` option for `swift test` is now deprecated.
  Use `--filter` instead which supports regex.

Swift 3.0
---------

* [SE-0135]

  The package manager now supports writing Swift 3.0 specific tags and
  manifests, in order to support future evolution of the formats used in both
  cases while still allowing the Swift 3.0 package manager to continue to
  function.

* [SE-0129]

  Test modules now *must* be named with a `Tests` suffix (e.g.,
  `Foo/Tests/BarTests/BarTests.swift`). This name also defines the name of the
  Swift module, replacing the old `BarTestSuite` module name.

* It is no longer necessary to run `swift build` before running `swift test` (it
  will always regenerates the build manifest when necessary). In addition, it
  now accepts (and requires) the same `-Xcc`, etc. options as are used with
  `swift build`.

* The `Package` initializer now requires the `name:` parameter.

[SE-0129]: https://github.com/apple/swift-evolution/blob/main/proposals/0129-package-manager-test-naming-conventions.md
[SE-0135]: https://github.com/apple/swift-evolution/blob/main/proposals/0135-package-manager-support-for-differentiating-packages-by-swift-version.md
[SE-0201]: https://github.com/apple/swift-evolution/blob/main/proposals/0201-package-manager-local-dependencies.md
[SE-0208]: https://github.com/apple/swift-evolution/blob/main/proposals/0208-package-manager-system-library-targets.md
[SE-0209]: https://github.com/apple/swift-evolution/blob/main/proposals/0209-package-manager-swift-lang-version-update.md
[SE-0332]: https://github.com/apple/swift-evolution/blob/main/proposals/0332-swiftpm-command-plugins.md

[SR-5918]: https://bugs.swift.org/browse/SR-5918
[SR-6978]: https://bugs.swift.org/browse/SR-6978
[SR-13566]: https://bugs.swift.org/browse/SR-13566

[#1485]: https://github.com/apple/swift-package-manager/pull/1485
[#1489]: https://github.com/apple/swift-package-manager/pull/1489
[#1604]: https://github.com/apple/swift-package-manager/pull/1604
[#2937]: https://github.com/apple/swift-package-manager/pull/2937
[#3280]: https://github.com/apple/swift-package-manager/pull/3280
[#3292]: https://github.com/apple/swift-package-manager/pull/3292
[#3310]: https://github.com/apple/swift-package-manager/pull/3310
[#3316]: https://github.com/apple/swift-package-manager/pull/3316
[#3410]: https://github.com/apple/swift-package-manager/pull/3410
[#3486]: https://github.com/apple/swift-package-manager/pull/3486
[#3641]: https://github.com/apple/swift-package-manager/pull/3641
[#3649]: https://github.com/apple/swift-package-manager/pull/3649
