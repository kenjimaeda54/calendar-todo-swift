//
//  ExtensionViewController.swift
//  Todo With Calendar
//
//  Created by kenjimaeda on 02/10/22.
//

import Foundation
import UIKit


//criando um extesion para nao precisar ficar chamando
//ManagerTaks.shared
extension UIViewController {
	func config() -> ManagerTaks  {
		let config = ManagerTaks.shared
	 return	config
	}
}
