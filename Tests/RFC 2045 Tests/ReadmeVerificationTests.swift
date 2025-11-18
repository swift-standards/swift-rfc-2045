import Testing

@testable import RFC_2045

@Suite("README Verification")
struct ReadmeVerificationTests {

    @Test("Example from README: Content-Type Examples")
    func exampleContentTypeExamples() throws {
        // From README lines 37-58

        // Simple text type
        let plain = RFC_2045.ContentType(type: "text", subtype: "plain")
        #expect(plain.type == "text")
        #expect(plain.subtype == "plain")

        // With charset parameter
        let html = RFC_2045.ContentType(
            type: "text",
            subtype: "html",
            parameters: ["charset": "UTF-8"]
        )
        #expect(html.headerValue == "text/html; charset=UTF-8")

        // Multipart with boundary
        let multipart = RFC_2045.ContentType(
            type: "multipart",
            subtype: "alternative",
            parameters: ["boundary": "----=_Part_1234"]
        )
        #expect(multipart.isMultipart == true)
        #expect(multipart.boundary == "----=_Part_1234")

        // Use in email headers
        let headers = [
            "Content-Type": html.headerValue  // "text/html; charset=UTF-8"
        ]
        #expect(headers["Content-Type"] == "text/html; charset=UTF-8")
    }

    @Test("Example from README: Content-Transfer-Encoding")
    func exampleContentTransferEncoding() {
        // From README lines 65-77

        // Common encodings
        let base64 = RFC_2045.ContentTransferEncoding.base64
        _ = RFC_2045.ContentTransferEncoding.quotedPrintable
        _ = RFC_2045.ContentTransferEncoding.sevenBit

        // Use in email headers
        let headers = [
            "Content-Transfer-Encoding": base64.headerValue  // "base64"
        ]
        #expect(headers["Content-Transfer-Encoding"] == "base64")

        // Check encoding properties
        #expect(base64.isBinarySafe == true)
        #expect(base64.isEncoded == true)
    }

    @Test("Example from README: Common Content Types")
    func exampleCommonContentTypes() {
        // From README lines 83-92

        // Preset content types
        let textPlain = RFC_2045.ContentType.textPlain
        #expect(textPlain.headerValue == "text/plain")

        let textPlainUTF8 = RFC_2045.ContentType.textPlainUTF8
        #expect(textPlainUTF8.charset == "UTF-8")

        let textHTML = RFC_2045.ContentType.textHTML
        #expect(textHTML.headerValue == "text/html")

        let textHTMLUTF8 = RFC_2045.ContentType.textHTMLUTF8
        #expect(textHTMLUTF8.headerValue == "text/html; charset=UTF-8")

        // Multipart types with boundary
        let alternative = RFC_2045.ContentType.multipartAlternative(boundary: "----=_Part_1234")
        #expect(alternative.isMultipart == true)

        let mixed = RFC_2045.ContentType.multipartMixed(boundary: "----=_Part_5678")
        #expect(mixed.boundary == "----=_Part_5678")
    }

    @Test("Example from README: Parsing Headers")
    func exampleParsingHeaders() throws {
        // From README lines 97-109

        // Parse Content-Type header
        let contentType = try RFC_2045.ContentType(
            parsing: "text/html; charset=UTF-8"
        )

        #expect(contentType.type == "text")
        #expect(contentType.subtype == "html")
        #expect(contentType.charset == "UTF-8")

        // Parse Content-Transfer-Encoding header
        let encoding = try RFC_2045.ContentTransferEncoding(parsing: "base64")
        #expect(encoding.headerValue == "base64")
    }
}
