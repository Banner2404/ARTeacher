//
//  AttachmentsTableViewController.swift
//  ARTeacher
//
//  Created by Евгений Соболь on 2/13/19.
//  Copyright © 2019 Eugene Sobol. All rights reserved.
//

import UIKit

class AttachmentsTableViewController: PreviewViewController {

    var annotation: Annotation!

    func load(textAttachment: TextAttachment) {
        let vc: TextAttachmentPreviewController = .loadFromStoryboard()
        vc.textAttachment = textAttachment
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension AttachmentsTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return annotation.attachments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentCell", for: indexPath)
        cell.textLabel?.text = annotation.attachments[indexPath.row].name
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AttachmentsTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let attachment = annotation.attachments[indexPath.row]
        switch attachment {
        case let attachment as TextAttachment:
            load(textAttachment: attachment)
        default:
            print("Unsopported attachment type")
        }
    }
}

