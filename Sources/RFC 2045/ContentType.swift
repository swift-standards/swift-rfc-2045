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

        /// Parses a Content-Type header value
        ///
        /// - Parameter headerValue: The header value (e.g., "text/html; charset=UTF-8")
        /// - Throws: `MIMEError` if the value is invalid
        public init(parsing headerValue: String) throws {
            let components = headerValue.split(separator: ";", maxSplits: 1)

            // Parse type/subtype
            guard let mediaType = components.first else {
                throw MIMEError.invalidContentType(headerValue)
            }

            let mediaComponents = mediaType.split(separator: "/")
            guard mediaComponents.count == 2 else {
                throw MIMEError.invalidMediaType(String(mediaType))
            }

            self.type = String(mediaComponents[0]).trimming(.whitespaces).lowercased()
            self.subtype = String(mediaComponents[1]).trimming(.whitespaces).lowercased()

            // Parse parameters if present
            var params: [RFC_2045.Parameter.Name: String] = [:]
            if components.count > 1 {
                let paramString = String(components[1])
                let paramPairs = paramString.split(separator: ";")

                for pair in paramPairs {
                    let keyValue = pair.split(separator: "=", maxSplits: 1)
                    guard keyValue.count == 2 else {
                        continue
                    }

                    let keyString = String(keyValue[0]).trimming(.whitespaces).lowercased()
                    let key = RFC_2045.Parameter.Name(rawValue: keyString)
                    var value = String(keyValue[1]).trimming(.whitespaces)

                    // Remove quotes if present
                    if value.hasPrefix("\"") && value.hasSuffix("\"") {
                        value = String(value.dropFirst().dropLast())
                    }

                    params[key] = value
                }
            }

            self.parameters = params
        }

        /// The complete header value
        ///
        /// Example: `"text/html; charset=UTF-8"`
        public var headerValue: String {
            var result = "\(type)/\(subtype)"

            for (key, value) in parameters.sorted(by: { $0.key < $1.key }) {
                // Quote value if it contains special characters per RFC 2045 Section 5.1
                let needsQuoting = value.contains(where: {
                    $0.isASCIIWhitespace || "()<>@,;:\\\"/[]?=".contains($0)
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

extension RFC_2045.ContentType: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        // swiftlint:disable:next force_try
        try! self.init(parsing: value)
    }
}
