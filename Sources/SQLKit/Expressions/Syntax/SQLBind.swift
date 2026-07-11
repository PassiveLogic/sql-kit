/// A parameterizied value bound to the SQL query.
public struct SQLBind: SQLExpression {
    /// The actual bound value.
    public let encodable: any SQLBindable & Sendable
    
    /// Create a binding to a value.
    @inlinable
    public init(_ encodable: any SQLBindable & Sendable) {
        self.encodable = encodable
    }
    
    /// Create a list of bindings to an array of values, with the placeholders wrapped in an ``SQLGroupExpression``.
    @inlinable
    public static func group(_ items: [any SQLBindable & Sendable]) -> any SQLExpression {
        SQLGroupExpression(items.map { SQLBind($0) as any SQLExpression })
    }

    // See `SQLExpression.serialize(to:)`.
    @inlinable
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write(bind: self.encodable)
    }
}
