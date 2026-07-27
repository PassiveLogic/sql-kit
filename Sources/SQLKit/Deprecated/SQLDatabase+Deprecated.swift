extension SQLDatabaseReportedVersion {
    /// Check whether the current version (i.e. `self`) is older than or equal to the one given.
    ///
    /// > Warning: This method has been deprecated; use the `<=` operator instead.
    ///
    /// - Parameters:
    ///   - otherVersion: The version to compare against. `type(of: self)` must be the same as `type(of: otherVersion)`.
    /// - Returns: `true` if `otherVersion` is greater than `self`, otherwise `false`.
    @inlinable
    @available(*, deprecated, renamed: "<=", message: "Use the `<=` operator instead.")
    public func isNotNewer(than otherVersion: any SQLDatabaseReportedVersion) -> Bool {
        // `as? Self` is a cast to a generic type (unavailable in Embedded Swift); call the
        // existential-based comparisons directly there.
        #if hasFeature(Embedded)
        self.isEqual(to: otherVersion) || self.isOlder(than: otherVersion)
        #else
        (otherVersion as? Self).map { self.isEqual(to: $0) || self.isOlder(than: $0) } ?? false
        #endif
    }
    
    /// Check whether the current version (i.e. `self`) is newer than the one given.
    ///
    /// > Warning: This method has been deprecated; use the `>` operator instead.
    ///
    /// - Parameters:
    ///   - otherVersion: The version to compare against. `type(of: self)` must be the same as `type(of: otherVersion)`.
    /// - Returns: `true` if `otherVersion` is equal to or less than `self`, otherwise `false`.
    @inlinable
    @available(*, deprecated, renamed: ">", message: "Use the `>` operator instead.")
    public func isNewer(than otherVersion: any SQLDatabaseReportedVersion) -> Bool {
        #if hasFeature(Embedded)
        !self.isNotNewer(than: otherVersion)
        #else
        (otherVersion as? Self).map { !self.isNotNewer(than: $0) } ?? false
        #endif
    }

    /// Check whether the current version (i.e. `self`) is newer than or equal to the one given.
    ///
    /// > Warning: This method has been deprecated; use the `>=` operator instead.
    ///
    /// - Parameters:
    ///   - otherVersion: The version to compare against. `type(of: self)` must be the same as `type(of: otherVersion)`.
    /// - Returns: `true` if `otherVersion` is less than `self`, otherwise `false`.
    @inlinable
    @available(*, deprecated, renamed: ">=", message: "Use the `>=` operator instead.")
    public func isNotOlder(than otherVersion: any SQLDatabaseReportedVersion) -> Bool {
        #if hasFeature(Embedded)
        !self.isOlder(than: otherVersion)
        #else
        (otherVersion as? Self).map { !self.isOlder(than: $0) } ?? false
        #endif
    }
}
