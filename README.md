# SwiftPlusPlusEval

_This repository is an attempt to successfully compile and test the [JacopoMangiavacchi SwiftPlusPlus](https://github.com/JacopoMangiavacchi/SwiftPlusPlus) package which provides a Swift Wrapper, calling a C Wrapper, calling a C++ wrapper, calling STL with Swift Package Manager (Linux)._

> Please see full instruction at <https://medium.com/@JMangia/swift-swift-c-c-stl-9e620e471145>

---

At this point in time, the package builds without errors on macOS. However, the test fails with the following errors.

```
XCTAssertEqual failed: ("Optional("p")") is not equal to ("Optional("0")")
XCTAssertEqual failed: ("Optional("p")") is not equal to ("Optional("2")")
```

---

_Highlight from Jacopo Mangiavacchi's Medium post ["Swift++ == Swift =&gt; C =&gt; C++ =&gt; STL"](https://medium.com/@JMangia/swift-swift-c-c-stl-9e620e471145) are noted below._

Swift Package supports for C language can directly import C Libraries (.so or .dylib). However, C++ class interaction are not a simple a C library interaction.

This package creates a Swift wrapper for the famous C++ `stl::list` template class. In particular, first a C++ Wrapper is created, then a C Wrapper and finally the Swift Wrapper. The goal is to recreate an interface similar to the original C++ code.

The constructs `void *` in C++ and `Data` in Swift are used to be as generic as possible.

## C++ Wrapper

The  `CPPListIterator` and `CPPListWrapper` C++ wrapper classes define the interfaces for the `std::iterator` and `std::list` classes in the standard C++ STL library.

## C Wrapper

Given the C++ class hierarchy to export in Swift, the next step to do is to de-objectify all the C++ interfaces and create a simple `extern "C"` interface, in C++.  

The exporting C methods wrap access to the `this` C++ instance with a `void *` object. The `void *` object is always passed as first parameter to all C interface methods.

## Swift Wrapper

Given the de-objectified C interface, then Swift classes with behaviors similar to the  original C++ classes can created. Alternately, a more "Swifty" wrapper can be created for the Swift side.

This example strives to similitude the original C++ interface as much as possible.

There is some complexity dealing with data conversion and memory management converting data from the Swift world to the `void *` generic pointers for the C++ `stl::list` implementation. Swift `Data` is used instead of `String` to keep the example more general. In this case, the Swift `Data` is converted back and forward to UnsafeRawPointer in order to pass a `void *` pointer.

## Swift Package and Folder organization

Finally in order to put all the C++, C and Swift source code in a unique project and just build everything with the `swift build` tool here are some advise about to easily manage your project subfolders and the main Swift Package file.

The subfolder organization used places `CPPListWrapper` within the `CListWrapper`. For simplicity the C++ Wrapper code in a separate (`CPPListWrapper`) subfolder, but this is not strictly needed.

This folder structure allows `Package.swift` to directly point to your C, and included C++.  The `include` subfolder under the C wrapper folder (`CListWrapper`) enables a `module.modulemap` file to be automatically generated.  Note that `CListWrapper.cpp` needs to state the include/ directory path `#include "include/CListWrapper.hpp"`.

``` sh
tree Sources/
# Sources/
# |-- CListWrapper
# |   |-- CListWrapper.cpp
# |   |-- CPPListWrapper
# |   |   |-- CPPListWrapper.cpp
# |   |   `-- CPPListWrapper.hpp
# |   `-- include
# |       `-- CListWrapper.hpp
# `-- SwiftPlusPlus
#     `-- SwiftPlusPlus.swift
```

## C++ 11 Features

Use the `-std=c++11` flag in the `swift build` command to enable C++ 11 features.

``` sh
# build:
swift build -Xcxx -std=c++11

# build release:
swift build --configuration release -Xcxx -std=c++11

# test:
swift test -Xcxx -std=c++11

# run:
swift run -Xcxx -std=c++11
```

## Resources

* [GitHub/JacopoMangiavacchi: SwiftPlusPlus](https://github.com/JacopoMangiavacchi/SwiftPlusPlus)
* [Medium: Jacopo Mangiavacchi ](https://medium.com/@JMangia)
    * [Swift++ == Swift => C => C++ => STL](https://medium.com/@JMangia/swift-swift-c-c-stl-9e620e471145) published Mar 16, 2018.
    