import Foundation
public import Standards

extension RFC_2045 {
    /// MIME parameter handling per RFC 2045 Section 5.1
    ///
    /// RFC 2045 defines the general syntax for MIME header parameters:
    /// ```
    /// parameter := attribute "=" value
    /// ```
    ///
    /// Both attribute names and values are case-insensitive per the RFC.
    public enum Parameter {}
}

extension RFC_2045.Parameter {
    /// Type-safe MIME parameter name with case-insensitive comparison.
    ///
    /// RFC 2045 Section 5.1 states:
    /// > Both attribute and value are case-insensitive
    ///
    /// This type ensures consistent handling of parameter names across all MIME headers
    /// (Content-Type, Content-Disposition, etc.).
    ///
    /// ## Example
    ///
    /// ```swift
    /// let charset: RFC_2045.Parameter.Name = .charset
    /// let custom = RFC_2045.Parameter.Name(rawValue: "Custom-Param")
    ///
    /// // Case-insensitive comparison
    /// charset == RFC_2045.Parameter.Name(rawValue: "CHARSET") // true
    /// ```
    public struct Name: Hashable, Sendable, Codable {
        /// The case-insensitive parameter name.
        private let storage: String.CaseInsensitive

        /// The canonical lowercased parameter name.
        public var rawValue: String {
            storage.value.lowercased()
        }

        /// Creates a parameter name from a raw string value.
        ///
        /// - Parameter rawValue: The parameter name string (case-insensitive).
        public init(rawValue: String) {
            self.storage = String.CaseInsensitive(rawValue)
        }

        /// Creates a parameter name from a case-insensitive string.
        ///
        /// - Parameter caseInsensitive: The case-insensitive parameter name.
        public init(_ caseInsensitive: String.CaseInsensitive) {
            self.storage = caseInsensitive
        }

        // MARK: - RFC 2045 Content-Type Parameters

        /// The charset parameter (RFC 2045 Section 4)
        ///
        /// Specifies the character set used in text/* media types.
        ///
        /// Example: `Content-Type: text/plain; charset=UTF-8`
        public static let charset = Name(rawValue: "charset")

        /// The boundary parameter (RFC 2045 Section 5.1)
        ///
        /// Specifies the boundary delimiter for multipart/* media types.
        ///
        /// Example: `Content-Type: multipart/mixed; boundary="----=_Part_1234"`
        public static let boundary = Name(rawValue: "boundary")

        /// The name parameter (RFC 2045 Section 2.3, deprecated by RFC 2183)
        ///
        /// Specifies a suggested filename. Deprecated in favor of Content-Disposition
        /// filename parameter per RFC 2183.
        ///
        /// Example: `Content-Type: application/pdf; name="document.pdf"`
        @available(*, deprecated, message: "Use Content-Disposition filename parameter per RFC 2183")
        public static let name = Name(rawValue: "name")
    }
}

// MARK: - Protocol Conformances

extension RFC_2045.Parameter.Name: RawRepresentable {}

extension RFC_2045.Parameter.Name: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

extension RFC_2045.Parameter.Name: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}

extension RFC_2045.Parameter.Name: Comparable {
    public static func < (lhs: RFC_2045.Parameter.Name, rhs: RFC_2045.Parameter.Name) -> Bool {
        lhs.storage < rhs.storage
    }
}
