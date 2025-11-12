# swift-rfc-2045

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Swift implementation of RFC 2045: Multipurpose Internet Mail Extensions (MIME) Part One

## Overview

This package provides a Swift implementation of MIME fundamentals as defined in [RFC 2045](https://www.rfc-editor.org/rfc/rfc2045.html). These types enable proper content type specification and transfer encoding for email messages.

## Features

- ✅ Content-Type header support (type/subtype with parameters)
- ✅ Content-Transfer-Encoding support (7bit, 8bit, binary, quoted-printable, base64)
- ✅ Type-safe Content-Type construction
- ✅ RFC-compliant header rendering
- ✅ Common content type presets
- ✅ Parameter handling (charset, boundary, etc.)
- ✅ Swift 6 strict concurrency support
- ✅ Full `Sendable` conformance

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-rfc-2045", branch: "main")
]
```

## Usage

### Content-Type

```swift
import RFC_2045

// Simple text type
let plain = RFC_2045.ContentType(type: "text", subtype: "plain")

// With charset parameter
let html = RFC_2045.ContentType(
    type: "text",
    subtype: "html",
    parameters: ["charset": "UTF-8"]
)

// Multipart with boundary
let multipart = RFC_2045.ContentType(
    type: "multipart",
    subtype: "alternative",
    parameters: ["boundary": "----=_Part_1234"]
)

// Use in email headers
let headers = [
    "Content-Type": html.headerValue  // "text/html; charset=UTF-8"
]
```

### Content-Transfer-Encoding

```swift
// Common encodings
let base64 = RFC_2045.ContentTransferEncoding.base64
let quotedPrintable = RFC_2045.ContentTransferEncoding.quotedPrintable
let sevenBit = RFC_2045.ContentTransferEncoding.sevenBit

// Use in email headers
let headers = [
    "Content-Transfer-Encoding": base64.headerValue  // "base64"
]

// Check encoding properties
base64.isBinarySafe  // true
base64.isEncoded     // true
```

### Common Content Types

```swift
// Preset content types
RFC_2045.ContentType.textPlain
RFC_2045.ContentType.textPlainUTF8
RFC_2045.ContentType.textHTML
RFC_2045.ContentType.textHTMLUTF8

// Multipart types with boundary
RFC_2045.ContentType.multipartAlternative(boundary: "----=_Part_1234")
RFC_2045.ContentType.multipartMixed(boundary: "----=_Part_5678")
```

### Parsing Headers

```swift
// Parse Content-Type header
let contentType = try RFC_2045.ContentType(
    parsing: "text/html; charset=UTF-8"
)

print(contentType.type)      // "text"
print(contentType.subtype)   // "html"
print(contentType.charset)   // "UTF-8"

// Parse Content-Transfer-Encoding header
let encoding = try RFC_2045.ContentTransferEncoding(parsing: "base64")
print(encoding.headerValue)  // "base64"
```

## Type Overview

### `RFC_2045.ContentType`

Represents the Content-Type header with type, subtype, and parameters.

```swift
public struct ContentType {
    public let type: String
    public let subtype: String
    public let parameters: [String: String]

    public var headerValue: String
    public var charset: String?
    public var boundary: String?
    public var isMultipart: Bool
    public var isText: Bool
}
```

### `RFC_2045.ContentTransferEncoding`

Represents the Content-Transfer-Encoding header.

```swift
public enum ContentTransferEncoding {
    case sevenBit        // "7bit"
    case eightBit        // "8bit"
    case binary          // "binary"
    case quotedPrintable // "quoted-printable"
    case base64          // "base64"

    public var headerValue: String
    public var isBinarySafe: Bool
    public var isEncoded: Bool
}
```

## RFC 2045 Compliance

This implementation follows RFC 2045 specifications:

- ✅ Content-Type format: `type/subtype; parameter=value`
- ✅ Case-insensitive type/subtype matching
- ✅ Parameter quoting for special characters
- ✅ All five standard transfer encodings
- ✅ Binary-safe encoding identification

## Requirements

- Swift 6.0+
- macOS 14+, iOS 17+, tvOS 17+, watchOS 10+

## Related RFCs

- [RFC 2045](https://www.rfc-editor.org/rfc/rfc2045.html) - MIME Part One: Format of Internet Message Bodies
- [RFC 2046](https://www.rfc-editor.org/rfc/rfc2046.html) - MIME Part Two: Media Types
- [RFC 2047](https://www.rfc-editor.org/rfc/rfc2047.html) - MIME Part Three: Header Extensions for Non-ASCII Text
- [RFC 5322](https://www.rfc-editor.org/rfc/rfc5322.html) - Internet Message Format

## Related Packages

- [swift-rfc-2046](https://github.com/coenttb/swift-rfc-2046) - MIME multipart media types
- [swift-rfc-5322](https://github.com/coenttb/swift-rfc-5322) - Internet Message Format

## License

Licensed under Apache 2.0.

## Contributing

Contributions welcome! Please ensure:
- All tests pass
- Code follows existing style
- RFC 2045 compliance maintained
