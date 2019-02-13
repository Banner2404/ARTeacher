//
//  TextAttachmentPreviewController.swift
//  ARTeacher
//
//  Created by Евгений Соболь on 2/13/19.
//  Copyright © 2019 Eugene Sobol. All rights reserved.
//

import UIKit

class TextAttachmentPreviewController: PreviewViewController {

    var textAttachment: TextAttachment!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = textAttachment.text
    }

}
