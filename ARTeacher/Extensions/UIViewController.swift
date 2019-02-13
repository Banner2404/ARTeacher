//
//  UIViewController.swift
//  ARTeacher
//
//  Created by Евгений Соболь on 2/13/19.
//  Copyright © 2019 Eugene Sobol. All rights reserved.
//

import UIKit

extension UIViewController {

    static func loadFromStoryboard<T: UIViewController>() -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let id = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: id) as! T
    }
}

