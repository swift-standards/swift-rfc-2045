import INCITS_4_1986

extension RFC_2045 {
    /// MIME Content-Type header
    ///
    /// Defines the media type of the content, consisting of a type, subtype,
    /// and optional parameters.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Simple text type
    /// let plain = RFC_2045.ContentType(type: "text", subtype: "plain")
    ///
    /// // With charset parameter (type-safe)
    /// let html = RFC_2045.ContentType(
    ///     type: "text",
    ///     subtype: "html",
    ///     parameters: [.charset: "UTF-8"]
    /// )
    ///
    /// // Multipart with boundary (string literals work via ExpressibleByStringLiteral)
    /// let multipart = RFC_2045.ContentType(
    ///     type: "multipart",
    ///     subtype: "alternative",
    ///     parameters: ["boundary": "----=_Part_1234"]
    /// )
    /// ```
    ///
    /// ## RFC Reference
    ///
    /// From RFC 2045 Section 5:
    ///
    /// > In general, the top-level media type is used to declare the general
    /// > type of data, while the subtype specifies a specific format for that
    /// > type of data.
    public struct ContentType: Hashable, Sendable, Codable {
        /// The primary media type (e.g., "text", "image", "multipart")
        public let type: String
        
        /// The media subtype (e.g., "plain", "html", "jpeg")
        public let subtype: String
        
        /// Optional parameters (e.g., [.charset: "UTF-8"])
        ///
        /// Uses type-safe `RFC_2045.Parameter.Name` for parameter names.
        /// String literals work via `ExpressibleByStringLiteral` conformance.
        public let parameters: [RFC_2045.Parameter.Name: String]
        
        /// Creates a new Content-Type
        ///
        /// - Parameters:
        ///   - type: Primary media type (case-insensitive)
        ///   - subtype: Media subtype (case-insensitive)
        ///   - parameters: Optional parameters with type-safe names
        public init(
            type: String,
            subtype: String,
            parameters: [RFC_2045.Parameter.Name: String] = [:]
        ) {
            self.type = type.lowercased()
            self.subtype = subtype.lowercased()
            self.parameters = parameters
        }
    }
}

extension RFC_2045.ContentType {
    /// Parses a Content-Type header from canonical byte representation
    ///
    /// This is the primitive parser that works at the byte level.
    /// RFC 2045 MIME headers are pure ASCII, so this parser operates on ASCII bytes.
    ///
    /// ## Category Theory
    ///
    /// This is the fundamental parsing transformation:
    /// - **Domain**: [UInt8] (ASCII bytes)
    /// - **Codomain**: RFC_2045.ContentType (structured data)
    ///
    /// String-based parsing is derived as composition:
    /// ```
    /// String → [UInt8] (UTF-8 bytes) → ContentType
    /// ```
    ///
    /// ## Example
    ///
    /// ```swift
    /// let bytes = Array("text/html; charset=UTF-8".utf8)
    /// let contentType = try RFC_2045.ContentType(parsing: bytes)
    /// ```
    ///
    /// - Parameter bytes: The ASCII byte representation of the header value
    /// - Throws: `MIMEError` if the bytes are malformed
    public init(ascii bytes: [UInt8]) throws {
        // Split on first semicolon to separate type/subtype from parameters
        let typeSubtypeBytes: ArraySlice<UInt8>
        let parametersBytes: ArraySlice<UInt8>?

        if let firstSemicolon = bytes.firstIndex(of: .ascii.semicolon) {
            typeSubtypeBytes = bytes[..<firstSemicolon]
            parametersBytes = bytes[(firstSemicolon + 1)...]
        } else {
            typeSubtypeBytes = bytes[...]
            parametersBytes = nil
        }

        // Parse type/subtype
        guard let solidus = typeSubtypeBytes.firstIndex(of: .ascii.solidus) else {
            throw RFC_2045.MIMEError.invalidMediaType(String(decoding: bytes, as: UTF8.self))
        }

        let typeBytes = typeSubtypeBytes[..<solidus].trimming(.ascii.whitespaces)
        let subtypeBytes = typeSubtypeBytes[(solidus + 1)...].trimming(.ascii.whitespaces)

        guard !typeBytes.isEmpty, !subtypeBytes.isEmpty else {
            throw RFC_2045.MIMEError.invalidMediaType(String(decoding: bytes, as: UTF8.self))
        }

        let type = String(decoding: typeBytes, as: UTF8.self).lowercased()
        let subtype = String(decoding: subtypeBytes, as: UTF8.self).lowercased()

        // Parse parameters if present
        var params: [RFC_2045.Parameter.Name: String] = [:]

        if let parametersBytes = parametersBytes {
            // Split on semicolons to get parameter pairs
            let paramPairs = parametersBytes.split(separator: .ascii.semicolon)

            for paramPair in paramPairs {
                // Split on equals to get key=value
                guard let equalsIndex = paramPair.firstIndex(of: .ascii.equalsSign) else {
                    continue
                }

                let keyBytes = paramPair[..<equalsIndex].trimming(.ascii.whitespaces)
                var valueBytes = Array(paramPair[(equalsIndex + 1)...].trimming(.ascii.whitespaces))

                guard !keyBytes.isEmpty else {
                    continue
                }

                // Handle quoted values
                if valueBytes.first == .ascii.quotationMark && valueBytes.last == .ascii.quotationMark {
                    // Remove surrounding quotes
                    valueBytes = Array(valueBytes.dropFirst().dropLast())
                }

                let key = RFC_2045.Parameter.Name(rawValue: String(decoding: keyBytes, as: UTF8.self).lowercased())
                let value = String(decoding: valueBytes, as: UTF8.self)

                params[key] = value
            }
        }

        // Use memberwise initializer
        self.init(type: type, subtype: subtype, parameters: params)
    }
}

extension RFC_2045.ContentType {
    
    /// Parses a Content-Type header value
    ///
    /// Composes through canonical byte representation for academic correctness.
    ///
    /// ## Category Theory
    ///
    /// Parsing composes as:
    /// ```
    /// String → [UInt8] (UTF-8) → ContentType
    /// ```
    ///
    /// - Parameter headerValue: The header value (e.g., "text/html; charset=UTF-8")
    /// - Throws: `MIMEError` if the value is invalid
    public init(header value: String) throws {
        // Convert to canonical byte representation (UTF-8, which is ASCII-compatible)
        let bytes = Array(headerValue.utf8)
        
        // Delegate to primitive byte-level parser
        try self.init(ascii: bytes)
    }
    
    /// The complete header value
    ///
    /// Example: `"text/html; charset=UTF-8"`
    public var headerValue: String {
        var result = "\(type)/\(subtype)"
        
        for (key, value) in parameters.sorted(by: { $0.key < $1.key }) {
            // Quote value if it contains special characters per RFC 2045 Section 5.1
            let needsQuoting = value.contains(where: {
                $0.ascii.isWhitespace || "()<>@,;:\\\"/[]?=".contains($0)
            })
            let quotedValue = needsQuoting ? "\"\(value)\"" : value
            result += "; \(key)=\(quotedValue)"
        }
        
        return result
    }
    
    /// Convenience accessor for charset parameter (type-safe)
    public var charset: RFC_2045.Charset? {
        parameters["charset"].map { RFC_2045.Charset($0) }
    }
    
    /// Convenience accessor for charset parameter (raw string)
    @available(*, deprecated, message: "Use charset property which returns RFC_2045.Charset instead")
    public var charsetString: String? {
        parameters["charset"]
    }
    
    /// Convenience accessor for boundary parameter (for multipart types)
    public var boundary: String? {
        parameters["boundary"]
    }
    
    /// Returns true if this is a multipart type
    public var isMultipart: Bool {
        type == "multipart"
    }
    
    /// Returns true if this is a text type
    public var isText: Bool {
        type == "text"
    }
}

// MARK: - Common Content Types

extension RFC_2045.ContentType {
    /// text/plain
    public static let textPlain = RFC_2045.ContentType(type: "text", subtype: "plain")
    
    /// text/plain; charset=UTF-8
    public static let textPlainUTF8 = RFC_2045.ContentType(
        type: "text",
        subtype: "plain",
        parameters: ["charset": RFC_2045.Charset.utf8.rawValue]
    )
    
    /// text/html
    public static let textHTML = RFC_2045.ContentType(type: "text", subtype: "html")
    
    /// text/html; charset=UTF-8
    public static let textHTMLUTF8 = RFC_2045.ContentType(
        type: "text",
        subtype: "html",
        parameters: ["charset": RFC_2045.Charset.utf8.rawValue]
    )
    
    /// Creates multipart/alternative with the given boundary
    public static func multipartAlternative(boundary: String) -> RFC_2045.ContentType {
        RFC_2045.ContentType(
            type: "multipart",
            subtype: "alternative",
            parameters: ["boundary": boundary]
        )
    }
    
    /// Creates multipart/mixed with the given boundary
    public static func multipartMixed(boundary: String) -> RFC_2045.ContentType {
        RFC_2045.ContentType(
            type: "multipart",
            subtype: "mixed",
            parameters: ["boundary": boundary]
        )
    }
    
    // MARK: Application Types
    
    /// application/octet-stream
    public static let applicationOctetStream = RFC_2045.ContentType(
        type: "application",
        subtype: "octet-stream"
    )
    
    /// Creates application/octet-stream with optional name parameter
    public static func applicationOctetStream(name: String? = nil) -> RFC_2045.ContentType {
        var params: [RFC_2045.Parameter.Name: String] = [:]
        if let name = name {
            params["name"] = name
        }
        return RFC_2045.ContentType(type: "application", subtype: "octet-stream", parameters: params)
    }
    
    /// application/pdf
    public static let applicationPDF = RFC_2045.ContentType(type: "application", subtype: "pdf")
    
    /// Creates application/pdf with optional name parameter
    public static func applicationPDF(name: String? = nil) -> RFC_2045.ContentType {
        var params: [RFC_2045.Parameter.Name: String] = [:]
        if let name = name {
            params["name"] = name
        }
        return RFC_2045.ContentType(type: "application", subtype: "pdf", parameters: params)
    }
    
    // MARK: Image Types
    
    /// image/jpeg
    public static let imageJPEG = RFC_2045.ContentType(type: "image", subtype: "jpeg")
    
    /// Creates image/jpeg with optional name parameter
    public static func imageJPEG(name: String? = nil) -> RFC_2045.ContentType {
        var params: [RFC_2045.Parameter.Name: String] = [:]
        if let name = name {
            params["name"] = name
        }
        return RFC_2045.ContentType(type: "image", subtype: "jpeg", parameters: params)
    }
    
    /// image/png
    public static let imagePNG = RFC_2045.ContentType(type: "image", subtype: "png")
    
    /// Creates image/png with optional name parameter
    public static func imagePNG(name: String? = nil) -> RFC_2045.ContentType {
        var params: [RFC_2045.Parameter.Name: String] = [:]
        if let name = name {
            params["name"] = name
        }
        return RFC_2045.ContentType(type: "image", subtype: "png", parameters: params)
    }
    
    /// image/gif
    public static let imageGIF = RFC_2045.ContentType(type: "image", subtype: "gif")
    
    /// Creates image/gif with optional name parameter
    public static func imageGIF(name: String? = nil) -> RFC_2045.ContentType {
        var params: [RFC_2045.Parameter.Name: String] = [:]
        if let name = name {
            params["name"] = name
        }
        return RFC_2045.ContentType(type: "image", subtype: "gif", parameters: params)
    }
}

// MARK: - Protocol Conformances

extension RFC_2045.ContentType: CustomStringConvertible {
    public var description: String { headerValue }
}
