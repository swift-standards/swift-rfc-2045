//
//  RFC_2045.ContentTransferEncoding.swift
//  swift-rfc-2045
//
//  Created by Coen ten Thije Boonkkamp on 19/11/2025.
//

public import INCITS_4_1986

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
    ///
    /// // Parse from string
    /// let parsed = try RFC_2045.ContentTransferEncoding("quoted-printable")
    /// ```
    ///
    /// ## RFC Reference
    ///
    /// From RFC 2045 Section 6:
    ///
    /// > The Content-Transfer-Encoding field's value is a single token
    /// > specifying the type of encoding, as enumerated below.
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

// MARK: - Serializing

extension RFC_2045.ContentTransferEncoding: UInt8.ASCII.Serializing {
    public static let serialize: @Sendable (Self) -> [UInt8] = [UInt8].init

    /// Parses a Content-Transfer-Encoding header from canonical byte representation (CANONICAL PRIMITIVE)
    ///
    /// This is the primitive parser that works at the byte level.
    /// RFC 2045 MIME headers are pure ASCII, so this parser operates on ASCII bytes.
    ///
    /// ## Category Theory
    ///
    /// This is the fundamental parsing transformation:
    /// - **Domain**: [UInt8] (ASCII bytes)
    /// - **Codomain**: RFC_2045.ContentTransferEncoding (structured data)
    ///
    /// String-based parsing is derived as composition:
    /// ```
    /// String → [UInt8] (UTF-8 bytes) → ContentTransferEncoding
    /// ```
    ///
    /// ## Example
    ///
    /// ```swift
    /// let bytes = Array("base64".utf8)
    /// let encoding = try RFC_2045.ContentTransferEncoding(ascii: bytes)
    /// ```
    ///
    /// - Parameter bytes: The ASCII byte representation of the header value
    /// - Throws: `RFC_2045.ContentTransferEncoding.Error` if the encoding is not recognized
    public init<Bytes: Collection>(ascii bytes: Bytes) throws(Error)
    where Bytes.Element == UInt8 {
        // Trim whitespace from collection
        var trimmedBytes = [UInt8]()
        var foundNonWhitespace = false
        var trailingWhitespace = [UInt8]()

        for byte in bytes {
            if byte == .ascii.space || byte == .ascii.htab {
                if foundNonWhitespace {
                    trailingWhitespace.append(byte)
                }
            } else {
                foundNonWhitespace = true
                trimmedBytes.append(contentsOf: trailingWhitespace)
                trailingWhitespace.removeAll()
                trimmedBytes.append(byte)
            }
        }

        guard !trimmedBytes.isEmpty else {
            throw Error.empty
        }

        let normalized = String(decoding: trimmedBytes, as: UTF8.self).lowercased()

        // Match directly to avoid protocol extension's init?(rawValue:) which would recurse
        switch normalized {
        case "7bit":
            self = .sevenBit
        case "8bit":
            self = .eightBit
        case "binary":
            self = .binary
        case "quoted-printable":
            self = .quotedPrintable
        case "base64":
            self = .base64
        default:
            throw Error.unrecognizedEncoding(String(decoding: bytes, as: UTF8.self))
        }
    }
}

// MARK: - Byte Serialization

extension [UInt8] {
    /// Creates ASCII byte representation of an RFC 2045 ContentTransferEncoding
    ///
    /// This is the canonical serialization of MIME Content-Transfer-Encoding headers to bytes.
    /// RFC 2045 MIME headers are ASCII-only by definition.
    ///
    /// ## Category Theory
    ///
    /// This is the most universal serialization (natural transformation):
    /// - **Domain**: RFC_2045.ContentTransferEncoding (structured data)
    /// - **Codomain**: [UInt8] (ASCII bytes)
    ///
    /// String representation is derived as composition:
    /// ```
    /// ContentTransferEncoding → [UInt8] (ASCII) → String (UTF-8 interpretation)
    /// ```
    ///
    /// ## Performance
    ///
    /// Zero-allocation: Returns static ASCII byte sequences.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let encoding = RFC_2045.ContentTransferEncoding.base64
    /// let bytes = [UInt8](encoding)
    /// // bytes represents "base64" as ASCII bytes
    /// ```
    ///
    /// - Parameter encoding: The transfer encoding to serialize
    public init(_ encoding: RFC_2045.ContentTransferEncoding) {
        switch encoding {
        case .sevenBit:
            // "7bit"
            self = [.ascii.`7`, .ascii.b, .ascii.i, .ascii.t]
        case .eightBit:
            // "8bit"
            self = [.ascii.`8`, .ascii.b, .ascii.i, .ascii.t]
        case .binary:
            // "binary"
            self = [.ascii.b, .ascii.i, .ascii.n, .ascii.a, .ascii.r, .ascii.y]
        case .quotedPrintable:
            // "quoted-printable"
            self = [
                .ascii.q, .ascii.u, .ascii.o, .ascii.t, .ascii.e, .ascii.d,
                .ascii.hyphen,
                .ascii.p, .ascii.r, .ascii.i, .ascii.n, .ascii.t, .ascii.a, .ascii.b, .ascii.l, .ascii.e
            ]
        case .base64:
            // "base64"
            self = [.ascii.b, .ascii.a, .ascii.s, .ascii.e, .ascii.`6`, .ascii.`4`]
        }
    }
}

// MARK: - Protocol Conformances

extension RFC_2045.ContentTransferEncoding: CustomStringConvertible {
    public var description: String { headerValue }
}
