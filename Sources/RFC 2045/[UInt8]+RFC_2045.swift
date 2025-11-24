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

// [UInt8]+RFC_2045.swift
// swift-rfc-2045
//
// Canonical byte serialization for RFC 2045 MIME types

import INCITS_4_1986
import Standards

// MARK: - ContentType Serialization

extension [UInt8] {
    /// Creates ASCII byte representation of an RFC 2045 ContentType
    ///
    /// This is the canonical serialization of MIME Content-Type headers to bytes.
    /// RFC 2045 MIME headers are ASCII-only by definition.
    ///
    /// ## Category Theory
    ///
    /// This is the most universal serialization (natural transformation):
    /// - **Domain**: RFC_2045.ContentType (structured data)
    /// - **Codomain**: [UInt8] (ASCII bytes)
    ///
    /// String representation is derived as composition:
    /// ```
    /// ContentType → [UInt8] (ASCII) → String (UTF-8 interpretation)
    /// ```
    ///
    /// ## Performance
    ///
    /// Efficient byte composition:
    /// - Single allocation with capacity estimation
    /// - Direct ASCII byte operations
    /// - No intermediate String allocations
    ///
    /// ## Example
    ///
    /// ```swift
    /// let contentType = RFC_2045.ContentType.textPlainUTF8
    /// let bytes = [UInt8](contentType)
    /// // bytes represents "text/plain; charset=UTF-8" as ASCII bytes
    /// ```
    ///
    /// - Parameter contentType: The content type to serialize
    public init(_ contentType: RFC_2045.ContentType) {
        self = []

        // Estimate capacity: type + "/" + subtype + parameters
        let estimatedCapacity = contentType.type.count + 1 + contentType.subtype.count +
                                (contentType.parameters.count * 30) // ~30 bytes per parameter
        self.reserveCapacity(estimatedCapacity)

        // Append type/subtype
        self.append(contentsOf: contentType.type.utf8)
        self.append(.ascii.solidus) // "/"
        self.append(contentsOf: contentType.subtype.utf8)

        // Append parameters in sorted order for consistency
        for (key, value) in contentType.parameters.sorted(by: { $0.key < $1.key }) {
            self.append(.ascii.semicolon) // ";"
            self.append(.ascii.space)
            self.append(contentsOf: key.rawValue.utf8)
            self.append(.ascii.equalsSign) // "="

            // Quote value if it contains special characters per RFC 2045 Section 5.1
            let needsQuoting = value.contains(where: {
                $0.ascii.isWhitespace || "()<>@,;:\\\"/[]?=".contains($0)
            })

            if needsQuoting {
                self.append(.ascii.quotationMark) // "\""
                self.append(contentsOf: value.utf8)
                self.append(.ascii.quotationMark) // "\""
            } else {
                self.append(contentsOf: value.utf8)
            }
        }
    }
}

// MARK: - ContentTransferEncoding Serialization

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
    /// Zero-cost: Returns rawValue bytes directly.
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
        // Zero-cost: direct conversion of rawValue to UTF-8 bytes
        self = Array(encoding.rawValue.utf8)
    }
}
