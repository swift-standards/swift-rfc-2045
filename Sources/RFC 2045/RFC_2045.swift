//
//  RFC_2045.swift
//  swift-rfc-2045
//
//  Created by Coen ten Thije Boonkkamp on 19/11/2025.
//

/// RFC 2045: Multipurpose Internet Mail Extensions (MIME) Part One
///
/// This module implements the fundamental MIME types defined in RFC 2045 for
/// message content formatting and encoding.
///
/// RFC 2045 defines:
/// - Content-Type header field (media types)
/// - Content-Transfer-Encoding header field
/// - Content-ID header field
/// - Content-Description header field
///
/// ## Usage Example
///
/// ```swift
/// // Define content type
/// let contentType = try RFC_2045.ContentType("text/html; charset=UTF-8")
///
/// // Define transfer encoding
/// let encoding = RFC_2045.ContentTransferEncoding.base64
///
/// // Use static constants
/// let textPlain = RFC_2045.ContentType.textPlainUTF8
/// ```
///
/// ## RFC Reference
///
/// From RFC 2045:
///
/// > MIME is intended to address deficiencies in the current internet
/// > electronic mail capabilities. It is not meant to be a complete
/// > replacement for RFC 822.
///
/// > The intent is to extend, not replace, the current RFC 822 environment.
public enum RFC_2045 {}
