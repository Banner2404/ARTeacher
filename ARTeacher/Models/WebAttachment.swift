//
//  WebAttachment.swift
//  ARTeacher
//
//  Created by Евгений Соболь on 2/13/19.
//  Copyright © 2019 Eugene Sobol. All rights reserved.
//

import Foundation

struct WebAttachment: Attachment {

    let name: String
    let urlString: String

    var url: URL? {
        return URL(string: urlString)
    }
}
