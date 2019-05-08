//
//  Attachment.swift
//  ARTeacher
//
//  Created by Евгений Соболь on 2/13/19.
//  Copyright © 2019 Eugene Sobol. All rights reserved.
//

import Foundation

protocol Attachment {

    var name: String { get }
}

enum AttachmentDecodable: Decodable {

    case text(TextAttachment)
    case web(WebAttachment)

    var attachment: Attachment {
        switch self {
        case .text(let attachment):
            return attachment
        case .web(let attachment):
            return attachment
        }
    }

    enum CodingKeys: String, CodingKey {
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "text":
            self = .text(try TextAttachment(from: decoder))
        case "web":
            self = .web(try WebAttachment(from: decoder))
        default:
            throw ParsingError.unsupportedType
        }
    }

    enum ParsingError: Error {
        case unsupportedType
    }
}
