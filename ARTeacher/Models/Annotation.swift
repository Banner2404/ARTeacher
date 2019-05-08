//
//  Annotation.swift
//  ARTeacher
//
//  Created by Евгений Соболь on 2/13/19.
//  Copyright © 2019 Eugene Sobol. All rights reserved.
//

import Foundation

struct Annotation: Decodable {

    let title: String
    let anchorId: String
    let attachments: [Attachment]

    enum CodingKeys: String, CodingKey {
        case title
        case anchorId
        case attachments
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.anchorId = try container.decode(String.self, forKey: .anchorId)
        self.attachments = try container.decode([AttachmentDecodable].self, forKey: .attachments).map { $0.attachment }
    }
}
