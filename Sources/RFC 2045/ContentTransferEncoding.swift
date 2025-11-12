import Foundation

extension RFC_2045 {
    /// MIME Content-Transfer-Encoding header
    ///
    /// Specifies the encoding transformation that was applied to the body
    /// to make it suitable for transport over the internet.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let encoding = RFC_2045.ContentTransferEncoding.base64
    /// print(encoding.headerValue) // "base64"
    /// ```
    ///
    /// ## RFC Reference
    ///
    /// From RFC 2045 Section 6:
    ///
    /// > The Content-Transfer-Encoding field is designed to specify an invertible
    /// > mapping between the "native" representation of a type of data and a
    /// > representation that can be readily exchanged using 7 bit mail transport
    /// > protocols.
    public enum ContentTransferEncoding: String, Hashable, Sendable, Codable {
        /// 7-bit ASCII (default)
        ///
        /// No encoding. Data must be 7-bit ASCII with lines no longer than 998 characters.
        case sevenBit = "7bit"

        /// 8-bit data
        ///
        /// No encoding. Data may contain 8-bit bytes but lines must be no longer
        /// than 998 characters.
        case eightBit = "8bit"

        /// Binary data
        ///
        /// No encoding. Data may contain arbitrary binary data with no line
        /// length restrictions.
        case binary = "binary"

        /// Quoted-printable encoding
        ///
        /// Encodes data using printable ASCII characters. Suitable for text
        /// that is mostly ASCII with occasional non-ASCII characters.
        case quotedPrintable = "quoted-printable"

        /// Base64 encoding
        ///
        /// Encodes arbitrary binary data into printable ASCII. Most common
        /// encoding for attachments and non-text content.
        case base64 = "base64"

        /// The header value string
        ///
        /// Example: `"base64"`
        public var headerValue: String {
            rawValue
        }

        /// Parses a Content-Transfer-Encoding header value
        ///
        /// - Parameter headerValue: The header value (e.g., "base64")
        /// - Throws: `MIMEError` if the encoding is not recognized
        public init(parsing headerValue: String) throws {
            let normalized =
                headerValue
                .trimmingCharacters(in: .whitespaces)
                .lowercased()

            guard let encoding = ContentTransferEncoding(rawValue: normalized) else {
                throw MIMEError.invalidEncoding(headerValue)
            }

            self = encoding
        }

        /// Returns true if this encoding is binary-safe
        ///
        /// Binary-safe encodings (base64, quoted-printable) can represent
        /// arbitrary binary data. Non-binary-safe encodings have restrictions.
        public var isBinarySafe: Bool {
            switch self {
            case .base64, .quotedPrintable:
                return true
            case .sevenBit, .eightBit, .binary:
                return false
            }
        }

        /// Returns true if this encoding requires special handling
        ///
        /// Encoded content (base64, quoted-printable) must be decoded before use.
        public var isEncoded: Bool {
            switch self {
            case .base64, .quotedPrintable:
                return true
            case .sevenBit, .eightBit, .binary:
                return false
            }
        }
    }
}

// MARK: - Protocol Conformances

extension RFC_2045.ContentTransferEncoding: CustomStringConvertible {
    public var description: String { headerValue }
}

extension RFC_2045.ContentTransferEncoding: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        // swiftlint:disable:next force_try
        try! self.init(parsing: value)
    }
}
