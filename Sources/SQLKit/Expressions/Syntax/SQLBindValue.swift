// SQLKit normally types bound-parameter values as `any Encodable`, letting the driver encode them via
// Codable. Embedded Swift has no Codable, so on that target the bind-parameter type is switched to a
// lightweight, driver-neutral `SQLBindValue` protocol. The `SQLBindable` typealias selects between the
// two so the rest of SQLKit's expression/serializer layer is unchanged save for the type name.
//
// (The Codable *model* encode/decode features — `set(model:)`, `insert(models:)`, `decode(model:)` —
// are separately gated out on embedded, since they fundamentally require Codable.)

#if hasFeature(Embedded)
/// A driver-neutral primitive value: the embedded substitute for whatever a driver would otherwise
/// extract from an `Encodable` bound parameter. Drivers map these cases to their own value type.
public enum SQLDataValue: Sendable {
    case integer(Int64)
    case double(Double)
    case string(String)
    case blob([UInt8])
    case bool(Bool)
    case null
}

/// The embedded substitute for `Encodable` as SQLKit's bound-parameter type.
///
/// On the embedded target, values bound into a query (e.g. `.where("x", .equal, 1)`) must conform to
/// this protocol instead of `Encodable`. The standard primitive types conform out of the box.
public protocol SQLBindValue: Sendable {
    /// The driver-neutral representation of this value.
    var sqlDataValue: SQLDataValue { get }
}

/// SQLKit's bound-parameter constraint. `SQLBindValue` in Embedded Swift; `Encodable` elsewhere.
public typealias SQLBindable = SQLBindValue

extension Int: SQLBindValue { public var sqlDataValue: SQLDataValue { .integer(Int64(self)) } }
extension Int8: SQLBindValue { public var sqlDataValue: SQLDataValue { .integer(Int64(self)) } }
extension Int16: SQLBindValue { public var sqlDataValue: SQLDataValue { .integer(Int64(self)) } }
extension Int32: SQLBindValue { public var sqlDataValue: SQLDataValue { .integer(Int64(self)) } }
extension Int64: SQLBindValue { public var sqlDataValue: SQLDataValue { .integer(self) } }
extension UInt: SQLBindValue { public var sqlDataValue: SQLDataValue { .integer(Int64(bitPattern: UInt64(self))) } }
extension UInt8: SQLBindValue { public var sqlDataValue: SQLDataValue { .integer(Int64(self)) } }
extension UInt16: SQLBindValue { public var sqlDataValue: SQLDataValue { .integer(Int64(self)) } }
extension UInt32: SQLBindValue { public var sqlDataValue: SQLDataValue { .integer(Int64(self)) } }
extension UInt64: SQLBindValue { public var sqlDataValue: SQLDataValue { .integer(Int64(bitPattern: self)) } }
extension Double: SQLBindValue { public var sqlDataValue: SQLDataValue { .double(self) } }
extension Float: SQLBindValue { public var sqlDataValue: SQLDataValue { .double(Double(self)) } }
extension String: SQLBindValue { public var sqlDataValue: SQLDataValue { .string(self) } }
extension Bool: SQLBindValue { public var sqlDataValue: SQLDataValue { .bool(self) } }
extension [UInt8]: SQLBindValue { public var sqlDataValue: SQLDataValue { .blob(self) } }
extension Optional: SQLBindValue where Wrapped: SQLBindValue {
    public var sqlDataValue: SQLDataValue { self?.sqlDataValue ?? .null }
}
#else
/// SQLKit's bound-parameter constraint. `SQLBindValue` in Embedded Swift; `Encodable` elsewhere.
public typealias SQLBindable = Encodable
#endif
