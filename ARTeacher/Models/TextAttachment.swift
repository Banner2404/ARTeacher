//
//  TextAttachment.swift
//  ARTeacher
//
//  Created by Евгений Соболь on 2/13/19.
//  Copyright © 2019 Eugene Sobol. All rights reserved.
//

import Foundation

struct TextAttachment: Attachment, Decodable {

    let name: String
    let title: String
    let text: String
}
