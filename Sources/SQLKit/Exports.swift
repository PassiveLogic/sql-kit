// EventLoop/EventLoopFuture are SwiftNIO types, elided on the NativeConcurrency (NIO-free) build.
#if !NativeConcurrency
@_documentation(visibility: internal) @_exported import protocol NIOCore.EventLoop
@_documentation(visibility: internal) @_exported import class NIOCore.EventLoopFuture
#endif
@_documentation(visibility: internal) @_exported import struct Logging.Logger
