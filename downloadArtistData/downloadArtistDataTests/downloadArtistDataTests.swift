//
//  downloadArtistDataTests.swift
//  downloadArtistDataTests
//
//  Created by Brooks Barnett on 8/2/21.
//

import XCTest
@testable import downloadArtistData
import Alamofire
import SwiftyJSON

class downloadArtistDataTests: XCTestCase {
    
    func testValidateArtistData() {
        let urlString = "https://itunes.apple.com/search"
        let artist = ""
        let url = URL(string: urlString)
        let parameters: Parameters = [ "term": artist ]
        var json: JSON?
        if (url != nil) {
            AF.request(url!, method: .get, parameters: parameters).responseJSON {
                response in
                if response.data != nil {
                    json = try? JSON(data: response.data!)
                    if !json!["results"].exists() {
                        json = "{}"
                    }
                    XCTAssertNotEqual(json, "{}", "Test complete")
                }
            }
        }
    }
    
}
