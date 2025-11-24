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

// StringProtocol+RFC_2045.swift
// swift-rfc-2045
//
// String representations composed through canonical byte serialization

// MARK: - ContentType String Representation

extension StringProtocol {
    /// Creates string representation of an RFC 2045 ContentType
    ///
    /// RFC 2045 MIME headers are pure ASCII (7-bit), and this initializer
    /// interprets them as UTF-8 (since ASCII ⊂ UTF-8).
    ///
    /// - Parameter contentType: The content type to represent
    public init(_ contentType: RFC_2045.ContentType) {
        self = Self(decoding: [UInt8](contentType), as: UTF8.self)
    }
}

// MARK: - ContentTransferEncoding String Representation

extension StringProtocol {
    /// Creates string representation of an RFC 2045 ContentTransferEncoding
    ///
    /// RFC 2045 MIME headers are pure ASCII (7-bit), and this initializer
    /// interprets them as UTF-8 (since ASCII ⊂ UTF-8).
    ///
    /// - Parameter transferEncoding: The transfer encoding to represent
    public init(_ transferEncoding: RFC_2045.ContentTransferEncoding) {
        self = Self(decoding: [UInt8](transferEncoding), as: UTF8.self)
    }
}
