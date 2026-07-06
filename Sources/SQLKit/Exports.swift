// EventLoop/EventLoopFuture are SwiftNIO types, elided on WASI (the WASI build is NIO-free / async).
#if !hasFeature(Embedded)
@_documentation(visibility: internal) @_exported import protocol NIOCore.EventLoop
@_documentation(visibility: internal) @_exported import class NIOCore.EventLoopFuture
#endif
@_documentation(visibility: internal) @_exported import struct Logging.Logger
