//
//  WebAttachmentPreviewController.swift
//  ARTeacher
//
//  Created by Евгений Соболь on 2/13/19.
//  Copyright © 2019 Eugene Sobol. All rights reserved.
//

import UIKit
import WebKit

class WebAttachmentPreviewController: PreviewViewController {

    @IBOutlet weak var webView: WKWebView!
    var attachment: WebAttachment!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem(with: attachment)
        guard let url = attachment.url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
