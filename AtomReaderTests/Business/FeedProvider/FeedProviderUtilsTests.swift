//
//  FeedProviderUtilsTests.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-13.
//

import XCTest
@testable import AtomReader

final class FeedProviderUtilsTests: XCTestCase {
    var sut: FeedProvider!
    
    override func setUp() {
        sut = FeedProvider(networkInterface: MockFeedProviderNetworkInterface())
    }
    
    func test_removeHtml_whenNoHtmlInString_sameStringReturned() {
        let html = """
        This is some sample html text
        hello there
        
        I am text
        """
        
        let text = sut.removeHtml(from: html)
        let expectedText = """
        This is some sample html text
        hello there
        
        I am text
        """
        
        XCTAssertEqual(text, expectedText)
    }
    
    func test_removeHtml_whenSelfClosingTagsPresent_tagsAreRemoved() {
        let html = """
        This is some sample html text
        hello there
        <br />
        I am text
        """
        
        let text = sut.removeHtml(from: html)
        let expectedText = """
        This is some sample html text
        hello there
        
        I am text
        """
        
        XCTAssertEqual(text, expectedText)
    }
    
    func test_removeHtml_whenContentTagsPresent_tagsAreRemoved() {
        let html = """
        This is some sample html text
        <p>hello there</p>
        
        <bold>I am text</bold>
        """
        
        let text = sut.removeHtml(from: html)
        let expectedText = """
        This is some sample html text
        hello there
        
        I am text
        """
        
        XCTAssertEqual(text, expectedText)
    }
    
    func test_removeHtml_whenTagsAreNested_tagsAreRemoved() {
        let html = """
        <div>This is some sample html text
        <p>hello <span>there</span></p>
        
        I am text</div>
        """
        
        let text = sut.removeHtml(from: html)
        let expectedText = """
        This is some sample html text
        hello there
        
        I am text
        """
        
        XCTAssertEqual(text, expectedText)
    }
    
    func test_removeHtml_whenTagsWithAttributesArePresent_tagsAreRemoved() {
        let html = """
        This is some sample html text
        <span class="some_class">hello there</span>
        
        <p class="another_class">I am text</p>
        """
        
        let text = sut.removeHtml(from: html)
        let expectedText = """
        This is some sample html text
        hello there
        
        I am text
        """
        
        XCTAssertEqual(text, expectedText)
    }
}
