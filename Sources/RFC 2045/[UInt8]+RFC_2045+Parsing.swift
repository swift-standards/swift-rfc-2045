// ===----------------------------------------------------------------------===//
//
// Copyright (c) 2025 Coen ten Thije Boonkkamp
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of project contributors
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------===//

// [UInt8]+RFC_2045+Parsing.swift
// swift-rfc-2045
//
// Byte-level parsing for RFC 2045 MIME types

import INCITS_4_1986
import Standards

// MARK: - ContentType Parsing



// MARK: - ContentTransferEncoding Parsing

extension RFC_2045.ContentTransferEncoding {
    /// Parses a Content-Transfer-Encoding header from canonical byte representation
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
    /// let encoding = try RFC_2045.ContentTransferEncoding(parsing: bytes)
    /// ```
    ///
    /// - Parameter bytes: The ASCII byte representation of the header value
    /// - Throws: `MIMEError` if the encoding is not recognized
    public init(ascii bytes: [UInt8]) throws {
        let trimmedBytes = bytes.trimming(.ascii.whitespaces)
        let normalized = String(decoding: trimmedBytes, as: UTF8.self).lowercased()

        guard let encoding = RFC_2045.ContentTransferEncoding(rawValue: normalized) else {
            throw RFC_2045.MIMEError.invalidEncoding(String(decoding: bytes, as: UTF8.self))
        }

        self = encoding
    }
}
