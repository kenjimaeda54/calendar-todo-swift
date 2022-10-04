# Todo 
Aplicação criada para registrar seus Todo

# Motivação 
Praticar conceitos em swit e manipular o sdk do [Realm Db](https://www.mongodb.com/docs/realm/sdk/swift/)


# Feature
- Realm Db recomenda o uso de classe para criar o seu model
- Criei um model dentro da camada MVC
- Utilizei singleton para evitar várias instancias do banco

```swift
import RealmSwift


class ManagerTaks {
	
	let realm = try! Realm()
	
	
	//singleton
	static var shared: ManagerTaks = ManagerTaks()
	private init() {
		
	}
	//
	
	func getAllTasks() -> Results<Task> {
		let tasks = realm.objects(Task.self)
		return tasks
	}
	
	
	func writeData(_ task: Task){
		do {
			try realm.write {
				realm.add(task)
			}
		}catch let error as NSError {
			print(error)
		}
	}
	
	func updateData(where id: ObjectId,update isCheck: Bool ) {
		let model = findOneTask(id)
		try!  realm.write{
			model.isCheck = isCheck
			model.task = model.task
		}
		NotificationCenter.default.post(name: Notification.Name("ObserveTask"), object: nil)
		
		
	}
	
	func findOneTask(_ id: ObjectId) -> Task {
		let model = realm.objects(Task.self).first {
			$0._id == id
		}
		return model!
	}
	
	func taskCompleted () -> Int {
		var finished = 0
		getAllTasks().forEach {
			if $0.isCheck {
				finished += 1
			}
			
		}
		return finished
	}
	
	func taskDelete(_ id:ObjectId)  {
		let task = findOneTask(id)
		try!  realm.write{
			realm.delete(task)
		}
		NotificationCenter.default.post(name:  Notification.Name("ObserveTask"), object: nil)
	}
}

```

##

- Apliquei conceito de adicionar um background personalizado no fundo da table view quando não possuir dados

```swift
//background
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


//no delegate

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let count = config().getAllTasks().count
		tableView.backgroundView = count > 0 ?  nil: prepareEmptyTask()
		return count
}

```



#

- Usei  override no bar style, porque cor de fundo do app era preto
- Apliquei extension para mudar a cor do placeholder do textField
- Após criar possível no IB  optar a cor
- Para acessibilidade utilizei o botão de retorno do próprio text field
- E necessário utilizar o [text field delegate](https://developer.apple.com/documentation/uikit/uitextfielddelegate/1619603-textfieldshouldreturn) e na IB ativar o botão retorno


```swift

//deixar claro o bar style,bateria,horas
override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
}

//extension placeholder
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

//extension textFieldDelegate
extension TaskViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if let text =  textField.text,textField.text!.count > 3 {
			let task = Task(task: text, isCheck: false)
			handleTaskAndTextField(task)
			return true
		}
		return false
	}
}

```
#
- Apliquei conceito de Notication para lidar com as mudanças ao adicionar, deletar e update de dados
- Com post eu crio a notificação 
- No object consigo enviar um dado e receber pelo addObserver

```swift
//quem vai enviar a notifcation
func updateData(where id: ObjectId,update isCheck: Bool ) {
		let model = findOneTask(id)
		try!  realm.write{
			model.isCheck = isCheck
			model.task = model.task
}
NotificationCenter.default.post(name: Notification.Name("ObserveTask"), object: nil)
}


//quem vai observar a notification
override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		//observer do notification
		NotificationCenter.default.addObserver(forName: Notification.Name("ObserveTask"), object: nil, queue: nil){[self](notification) in
			let count = config().taskCompleted()
			labQuantityFinishedTask.text = "\(count)"
			let taskCreate = config().getAllTasks().count
			labQuantityCreateTask.text =  "\(taskCreate)"
			tableViewTask.reloadData()
		}
		
		navigationController?.navigationBar.barStyle = .black
}

```






