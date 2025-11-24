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

// MARK: - Web Content Type Extensions

extension RFC_2045.ContentType {
    // MARK: - Video Types

    /// video/mp4
    public static let videoMP4 = RFC_2045.ContentType(type: "video", subtype: "mp4")

    /// video/webm
    public static let videoWebM = RFC_2045.ContentType(type: "video", subtype: "webm")

    /// video/ogg
    public static let videoOgg = RFC_2045.ContentType(type: "video", subtype: "ogg")

    // MARK: - Audio Types

    /// audio/mpeg (MP3)
    public static let audioMPEG = RFC_2045.ContentType(type: "audio", subtype: "mpeg")

    /// audio/ogg
    public static let audioOgg = RFC_2045.ContentType(type: "audio", subtype: "ogg")

    /// audio/wav
    public static let audioWav = RFC_2045.ContentType(type: "audio", subtype: "wav")

    /// audio/webm
    public static let audioWebM = RFC_2045.ContentType(type: "audio", subtype: "webm")

    // MARK: - Image Types

    /// image/webp
    public static let imageWEBP = RFC_2045.ContentType(type: "image", subtype: "webp")

    /// image/avif
    public static let imageAVIF = RFC_2045.ContentType(type: "image", subtype: "avif")

    /// image/svg+xml
    public static let imageSVG = RFC_2045.ContentType(type: "image", subtype: "svg+xml")

    /// image/x-icon (Favicon)
    public static let imageXIcon = RFC_2045.ContentType(type: "image", subtype: "x-icon")

    // MARK: - Text Types

    /// text/css
    public static let textCSS = RFC_2045.ContentType(type: "text", subtype: "css")

    /// text/javascript
    public static let textJavaScript = RFC_2045.ContentType(type: "text", subtype: "javascript")

    // MARK: - Application Types

    /// application/json (JSON)
    public static let applicationJSON = RFC_2045.ContentType(type: "application", subtype: "json")

    /// application/manifest+json (Web App Manifest)
    public static let applicationManifestJSON = RFC_2045.ContentType(type: "application", subtype: "manifest+json")

    /// application/rss+xml (RSS Feed)
    public static let applicationRSSXML = RFC_2045.ContentType(type: "application", subtype: "rss+xml")

    /// application/atom+xml (Atom Feed)
    public static let applicationAtomXML = RFC_2045.ContentType(type: "application", subtype: "atom+xml")

    /// application/x-www-form-urlencoded
    public static let applicationXWWWFormURLEncoded = RFC_2045.ContentType(type: "application", subtype: "x-www-form-urlencoded")
}
