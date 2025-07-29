#!/bin/bash

# build harper_ffi.a for x86 and arm
cargo build --release --target x86_64-apple-darwin
cargo build --release --target aarch64-apple-darwin

# make fat binary for both libraries versions
lipo -create target/aarch64-apple-darwin/release/libharper_ffi.a target/x86_64-apple-darwin/release/libharper_ffi.a -output libharper_ffi_universal.a

# make xcframweork file
xcodebuild -create-xcframework -library libharper_ffi_universal.a -output HarperFFI.xcframework
