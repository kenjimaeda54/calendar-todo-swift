//
//  ManagerTask.swift
//  Todo With Calendar
//
//  Created by kenjimaeda on 01/10/22.
//

import Foundation
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

