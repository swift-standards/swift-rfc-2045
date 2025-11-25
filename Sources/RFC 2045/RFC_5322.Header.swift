//
//  RFC_5322.Header.swift
//  swift-rfc-2045
//
//  Created by Coen ten Thije Boonkkamp on 19/11/2025.
//

public import RFC_5322

// MARK: - Header Transformations

extension RFC_5322.Header {
    /// Creates a Content-Type header from RFC 2045 ContentType
    ///
    /// Transforms typed ContentType to RFC 5322 Header format.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let contentType = RFC_2045.ContentType.textPlainUTF8
    /// let header = try RFC_5322.Header(contentType)
    /// // Header(name: .contentType, value: "text/plain; charset=UTF-8")
    /// ```
    public init(_ contentType: RFC_2045.ContentType) throws {
        try self.init(name: .contentType, value: .init(contentType))
    }

    /// Creates a Content-Transfer-Encoding header from RFC 2045 ContentTransferEncoding
    ///
    /// Transforms typed ContentTransferEncoding to RFC 5322 Header format.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let encoding = RFC_2045.ContentTransferEncoding.base64
    /// let header = try RFC_5322.Header(encoding)
    /// // Header(name: .contentTransferEncoding, value: "base64")
    /// ```
    public init(_ encoding: RFC_2045.ContentTransferEncoding) throws {
        try self.init(name: .contentTransferEncoding, value: .init(encoding))
    }
}
