//
//  String.swift
//  swift-rfc-2045
//
//  Created by Coen ten Thije Boonkkamp on 19/11/2025.
//

// MARK: - ContentType String Transformation

extension String {
    /// Creates header value string from RFC 2045 ContentType
    ///
    /// Renders the media type and parameters as a header value (without "Content-Type:" prefix).
    ///
    /// ## Example
    ///
    /// ```swift
    /// let contentType = RFC_2045.ContentType.textPlainUTF8
    /// let value = String(contentType)
    /// // "text/plain; charset=UTF-8"
    /// ```
    public init(_ contentType: RFC_2045.ContentType) {
        var result = "\(contentType.type)/\(contentType.subtype)"

        // Add parameters in sorted order for consistency
        for (key, value) in contentType.parameters.sorted(by: { $0.key < $1.key }) {
            result += "; \(key)=\(value)"
        }

        self = result
    }
}

// MARK: - ContentTransferEncoding String Transformation

extension String {
    /// Creates header value string from RFC 2045 ContentTransferEncoding
    ///
    /// Renders the encoding mechanism as a header value (without "Content-Transfer-Encoding:" prefix).
    ///
    /// ## Example
    ///
    /// ```swift
    /// let encoding = RFC_2045.ContentTransferEncoding.base64
    /// let value = String(encoding)
    /// // "base64"
    /// ```
    public init(_ encoding: RFC_2045.ContentTransferEncoding) {
        self = encoding.rawValue
    }
}
