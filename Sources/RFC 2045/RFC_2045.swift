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
/// let contentType = RFC_2045.ContentType(
///     type: "text",
///     subtype: "html",
///     parameters: ["charset": "UTF-8"]
/// )
///
/// // Define transfer encoding
/// let encoding = RFC_2045.ContentTransferEncoding.quotedPrintable
///
/// // Render to email headers
/// let headers = [
///     "Content-Type": contentType.headerValue,
///     "Content-Transfer-Encoding": encoding.headerValue
/// ]
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
public enum RFC_2045 {
    /// Errors that can occur when working with MIME headers
    public enum MIMEError: Error, Hashable, Sendable {
        case invalidContentType(String)
        case invalidMediaType(String)
        case invalidParameter(String)
        case invalidEncoding(String)
    }
}
