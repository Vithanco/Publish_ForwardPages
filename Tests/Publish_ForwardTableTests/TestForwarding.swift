//
//  File.swift
//  
//
//  Created by Klaus Kneupner on 31/05/2023.
//

import XCTest
@testable import Publish
import Files
import Plot
@testable import Publish_ForwardTable


// MARK: - TestWebsite

private struct TestWebsite: Website {
    enum SectionID: String, WebsiteSectionID {
        case test
    }

    struct ItemMetadata: WebsiteItemMetadata {
    }
    
    var url = URL(string: "http://httpbin.org")!
    var name = "test"
    var description = ""
    var language: Language = .english
    var imagePath: Path? = nil
    var fileMode: Publish.HTMLFileMode = .standAloneFiles
}


final class TestForwarding: XCTestCase {
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testForwarding() throws {

       let test1 = Forward("testOld", "testNew")
       let test2 = Forward("testOld",  "testNew",onPage: "section")
       let test3 = Forward("newsletter","https://newsletter.vithanco.com")
        
//        let sourceLocation = HTMLFileMode.standAloneFiles.filePath(string: test1.from)
//        XCTAssertThrowsError( try context.createOutputFile(at: sourceLocation))
//
        XCTAssertTrue (test1.forwardPage.render().contains("\"/testNew\""))
        XCTAssertTrue (test2.forwardPage.render().contains("\"/testNew#section\""))
        XCTAssertTrue (test3.forwardPage.render().contains("\"https://newsletter.vithanco.com\""))
        
    }
}
