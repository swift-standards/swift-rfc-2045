import Foundation

extension RFC_2045 {
    /// Character set identifier for MIME content
    ///
    /// Represents character encodings used in MIME content types.
    /// Defined in RFC 2045 Section 5.1 as part of Content-Type parameters.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let utf8 = RFC_2045.Charset.utf8
    /// let custom = RFC_2045.Charset("ISO-8859-1")
    /// ```
    ///
    /// ## RFC Reference
    ///
    /// From RFC 2045 Section 5.1:
    ///
    /// > The "charset" parameter specifies the character set used to
    /// > encode the data in the body part.
    ///
    /// ## Common Character Sets
    ///
    /// The most commonly used character sets are available as static properties:
    /// - `utf8`: UTF-8 encoding (recommended for most use cases)
    /// - `usASCII`: US-ASCII encoding
    /// - `iso88591`: ISO-8859-1 (Latin-1) encoding
    ///
    /// Custom character sets can be created using the string-based initializer.
    public struct Charset: Hashable, Sendable, Codable {
        /// The IANA charset identifier
        public let rawValue: String

        /// Creates a charset with the given identifier
        ///
        /// - Parameter rawValue: IANA charset identifier (case-insensitive)
        public init(_ rawValue: String) {
            // Charset identifiers are case-insensitive per RFC 2045
            self.rawValue = rawValue.uppercased()
        }
    }
}

// MARK: - Common Charsets

extension RFC_2045.Charset {
    /// UTF-8 character encoding (recommended)
    public static let utf8 = RFC_2045.Charset("UTF-8")

    /// US-ASCII character encoding (7-bit)
    public static let usASCII = RFC_2045.Charset("US-ASCII")

    /// ISO-8859-1 (Latin-1) character encoding
    public static let iso88591 = RFC_2045.Charset("ISO-8859-1")

    /// UTF-16 character encoding
    public static let utf16 = RFC_2045.Charset("UTF-16")

    /// UTF-16BE (Big Endian) character encoding
    public static let utf16BE = RFC_2045.Charset("UTF-16BE")

    /// UTF-16LE (Little Endian) character encoding
    public static let utf16LE = RFC_2045.Charset("UTF-16LE")

    /// UTF-32 character encoding
    public static let utf32 = RFC_2045.Charset("UTF-32")

    /// ISO-8859-2 (Latin-2) character encoding
    public static let iso88592 = RFC_2045.Charset("ISO-8859-2")

    /// ISO-8859-15 (Latin-9) character encoding
    public static let iso885915 = RFC_2045.Charset("ISO-8859-15")

    /// Windows-1252 (Western European) character encoding
    public static let windows1252 = RFC_2045.Charset("Windows-1252")
}

// MARK: - Protocol Conformances

extension RFC_2045.Charset: ExpressibleByStringLiteral {
    /// Creates a charset from a string literal
    ///
    /// Allows convenient syntax: `let charset: Charset = "UTF-8"`
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension RFC_2045.Charset: CustomStringConvertible {
    /// Returns the IANA charset identifier
    public var description: String {
        rawValue
    }
}
