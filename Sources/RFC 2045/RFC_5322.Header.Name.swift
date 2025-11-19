//
//  RFC_5322.Header.Name.swift
//  swift-rfc-2045
//
//  Created by Coen ten Thije Boonkkamp on 19/11/2025.
//

import RFC_5322

// MARK: - MIME Headers (RFC 2045)

extension RFC_5322.Header.Name {
    /// Content-Type: header (media type)
    ///
    /// Defined in RFC 2045 Section 5: "Content-Type Header Field"
    public static let contentType: Self = "Content-Type"

    /// Content-Transfer-Encoding: header
    ///
    /// Defined in RFC 2045 Section 6: "Content-Transfer-Encoding Header Field"
    public static let contentTransferEncoding: Self = "Content-Transfer-Encoding"

    /// MIME-Version: header
    ///
    /// Defined in RFC 2045 Section 4: "MIME-Version Header Field"
    public static let mimeVersion: Self = "MIME-Version"

    /// Content-ID: header
    ///
    /// Defined in RFC 2045 Section 7: "Content-ID Header Field"
    public static let contentId: Self = "Content-ID"

    /// Content-Description: header
    ///
    /// Defined in RFC 2045 Section 8: "Content-Description Header Field"
    public static let contentDescription: Self = "Content-Description"
}
