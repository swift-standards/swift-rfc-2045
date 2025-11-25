//
//  RFC_2045.Parameter.swift
//  swift-rfc-2045
//
//  Created by Coen ten Thije Boonkkamp on 19/11/2025.
//

extension RFC_2045 {
    /// MIME parameter handling per RFC 2045 Section 5.1
    ///
    /// RFC 2045 defines the general syntax for MIME header parameters:
    /// ```
    /// parameter := attribute "=" value
    /// ```
    ///
    /// Both attribute names and values are case-insensitive per the RFC.
    public enum Parameter {}
}
