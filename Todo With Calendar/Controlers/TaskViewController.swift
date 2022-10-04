//
//  ViewController.swift
//  Todo With Calendar
//
//  Created by kenjimaeda on 14/09/22.
//

import UIKit

class TaskViewController: UIViewController {
	
	@IBOutlet weak var labQuantityCreateTask: UILabel!
	@IBOutlet weak var labQuantityFinishedTask: UILabel!
	@IBOutlet weak var viFinished: UIView!
	@IBOutlet weak var textFieldTask: UITextField!
	@IBOutlet weak var viCreate: UIView!
	@IBOutlet weak var tableViewTask: UITableView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableViewTask.delegate = self
		tableViewTask.dataSource = self
		textFieldTask.delegate = self
		tableViewTask.register(UINib(nibName: "TasksTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
		viCreate.layer.cornerRadius = 6
		viFinished.layer.cornerRadius = 6
		let count = config().taskCompleted()
		labQuantityFinishedTask.text = "\(count)"
	  let taskCreate = config().getAllTasks().count
		labQuantityCreateTask.text =  "\(taskCreate)"
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		//observer do notification
		NotificationCenter.default.addObserver(forName: Notification.Name("TaskFinished"), object: nil, queue: nil){[self](notification) in
			let count = config().taskCompleted()
			labQuantityFinishedTask.text = "\(count)"
		}
	
		navigationController?.navigationBar.barStyle = .black
	}
	
	
	
	
	func prepareEmptyTask() -> UIView {
		let background = UIView()
		let img = makeImg()
		let labelTitle = makeLabel(text: "Você ainda não tem tarefas cadastradas", font: "Inter-Bold")
		let labelSubTitle = makeLabel(text: "Crie tarefas e organize seus itens a fazer", font: "Inter-Regular")
		let viewSeparator = makeView()
		
		view.addSubview(background)
		
		background.addSubview(viewSeparator)
		background.addSubview(img)
		background.addSubview(labelTitle)
		background.addSubview(labelSubTitle)
		
		NSLayoutConstraint.activate([
			
			//MARK: - viewSeparator
			viewSeparator.topAnchor.constraint(equalTo: viCreate.bottomAnchor,constant: 17),
			viewSeparator.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24),
			viewSeparator.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -24),
			viewSeparator.heightAnchor.constraint(equalToConstant: 1),
			
			//MARK: - img
			img.topAnchor.constraint(equalTo: viewSeparator.bottomAnchor,constant: 47),
			img.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			img.heightAnchor.constraint(equalToConstant: 56),
			img.widthAnchor.constraint(equalToConstant:  56),
			
			//MARK: - label title
			labelTitle.topAnchor.constraint(equalTo: img.bottomAnchor,constant: 25),
			labelTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			//MARK: - label subtitle
			labelSubTitle.topAnchor.constraint(equalTo: labelTitle.bottomAnchor,constant: 1),
			labelSubTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
		])
		return background
	}
	
	//deixar claro o bar style,bateria,horas
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	func handleTaskAndTextField(_ task: Task)  {
		config().writeData(task)
		tableViewTask.reloadData()
		textFieldTask.resignFirstResponder()
		textFieldTask.text = nil
		textFieldTask.placeholder = "Adicione mais tarefas"
		let taskCompleted = config().taskCompleted()
		labQuantityFinishedTask.text = "\(taskCompleted)"
		let taskCreate = config().getAllTasks().count
		labQuantityCreateTask.text =  "\(taskCreate)"
	}
	
	@IBAction func handleTask(_ sender: UIButton) {
		if let text = textFieldTask.text,textFieldTask.text!.count > 3  {
			let task = Task(task: text, isCheck: false)
			handleTaskAndTextField(task)
		}
	}
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let count = config().getAllTasks().count
		tableView.backgroundView = count > 0 ?  nil: prepareEmptyTask()
		return count
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableViewTask.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TasksTableViewCell
		let taskModel = config().getAllTasks()[indexPath.row]
		cell.labTask.text = taskModel.task
		cell.id = taskModel._id
		cell.prepareViCheck(taskModel._id)
		return cell
		
	}
}



//aqui vai ficar a extension para placeholder
//change color placeholder
//MARK: - Extension TextField
extension UITextField{
	@IBInspectable var placeHolderColor: UIColor? {
		get {
			return self.placeHolderColor
		}
		set {
			self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor : newValue!])
		}
	}
}

//MARK: - UITextFieldDelegate
extension TaskViewController: UITextFieldDelegate {
	
	//  quando cliar no botao de return 	referencia https://developer.apple.com/documentation/uikit/uitextfielddelegate/1619603-textfieldshouldreturn
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if let text =  textField.text,textField.text!.count > 3 {
			let task = Task(task: text, isCheck: false)
			handleTaskAndTextField(task)
			return true
		}
		return false
	}
}
