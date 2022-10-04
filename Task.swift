//
//  ModelRealmDb.swift
//  Todo With Calendar
//
//  Created by kenjimaeda on 02/10/22.
//

import Foundation
import RealmSwift

class Task: Object  {
	@Persisted(primaryKey: true) var _id: ObjectId
	@Persisted var task: String =  ""
	@Persisted var isCheck: Bool = false
	
	convenience init(task: String, isCheck: Bool) {
		self.init()
		self.task = task
		self.isCheck = isCheck
	}
}
