// Performance Tests.swift
// swift-rfc-2045
//
// Top-level performance test suite with serialized execution.
// All performance tests extend this suite via extension in their respective test files.

import Testing

@Suite(.serialized)
struct `Performance Tests` {}
