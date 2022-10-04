//
//  TasksTableViewCell.swift
//  Todo With Calendar
//
//  Created by kenjimaeda on 16/09/22.
//

import UIKit
import RealmSwift


class TasksTableViewCell: UITableViewCell {
	
	@IBOutlet weak var nsWidth: NSLayoutConstraint!
	@IBOutlet weak var nsHeight: NSLayoutConstraint!
	@IBOutlet weak var btnCheck: UIButton!
	@IBOutlet weak var cellMain: UIView!
	@IBOutlet weak var labTask: UILabel!
	@IBOutlet weak var btnTrash: UIButton!
	
	var id: ObjectId!
	var isCheck = false
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		
		//prepare a celula princiapl
		cellMain.layer.cornerRadius = 8
		cellMain.layer.shadowOffset.height = 2
		cellMain.layer.shadowColor = UIColor.black.cgColor
		cellMain.layer.shadowOpacity = 0.3
	}
	
	
	func prepareViCheck(_ id: ObjectId) {
		
		//disparando uma notificacao para alterar o count
		NotificationCenter.default.post(name: Notification.Name("TaskFinished"), object: nil)

		if ManagerTaks.shared.findOneTask(id).isCheck {
			let image =   UIImage(named: "check")
			//peguei a constraint para aumentar altura e largura
			nsWidth.constant = 20
			nsHeight.constant = 20
			
			//adicionar um corte no meio
			//referencia: https://stackoverflow.com/questions/13133014/how-can-i-create-a-uilabel-with-strikethrough-text
			let attributedText = NSAttributedString(
				string: labTask.text ?? "",
				attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
			)
			labTask.attributedText = attributedText
			
			btnCheck.setBackgroundImage(image, for: .normal)
			btnCheck.layer.borderWidth = 0
			btnCheck.layer.cornerRadius = 0
			
			//estou pegando a medida que esta o eixo x e y da view viCheck e substituindo uma imagem
			//assim a imagem ficara na mesma posicao que o vi check
			//			let frameView: CGRect = CGRect(x: btnCheck.frame.origin.x, y: btnCheck.frame.origin.y - 6, width: 25, height: 25)
			//			imageView.frame = frameView
			//
			//			contentView.addSubview(imageView)
			
			return
		}
		
		
		//prepare o botao
		btnCheck.layer.cornerRadius = 8
		btnCheck.layer.borderWidth = 2
		nsWidth.constant = 16
		nsHeight.constant = 16
		btnCheck.layer.borderColor = UIColor(named: "bluePrimary")?.cgColor
		btnCheck.backgroundColor = .clear
		btnCheck.removeBackground(for: .normal)
		
		let attributedText = NSAttributedString(
			string: labTask.text ?? "",
			attributes: [.strikethroughStyle: NSMakeRange(0, labTask.text!.count)]
			
		)
		labTask.attributedText = attributedText
		
	}
	
	@IBAction func btnCheckedTask(_ sender: UIButton) {
		isCheck = !isCheck
		ManagerTaks.shared.updateData(where: id,update: isCheck)
		prepareViCheck(id)
	}
	
}

//para remover background button
extension UIButton {
	func removeBackground(for state: UIControl.State) {
		setBackgroundImage(nil, for: state)
	}
}
