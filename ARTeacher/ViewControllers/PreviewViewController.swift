//
//  PreviewController.swift
//  ARTeacher
//
//  Created by Евгений Соболь on 2/13/19.
//  Copyright © 2019 Eugene Sobol. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBAction func closeButtonTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func setupNavigationItem(with attachment: Attachment) {
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeButtonTap(_:)))
        navigationItem.rightBarButtonItem = closeButton
        navigationItem.title = attachment.name
    }
}
