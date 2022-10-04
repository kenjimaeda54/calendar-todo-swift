//
//  Factories.swift
//  Todo With Calendar
//
//  Created by kenjimaeda on 19/09/22.
//

import Foundation
import UIKit



func makeView() -> UIView {
	let view = UIView()
	view.backgroundColor = UIColor(named: "grayUniversal")
	view.translatesAutoresizingMaskIntoConstraints = false
	return view
}

func makeImg() -> UIImageView {
	let img = UIImageView(image: UIImage(named: "clipBoard"))
	img.translatesAutoresizingMaskIntoConstraints = false
	return img
}

func makeLabel(text: String,font: String)-> UILabel {
	let label = UILabel()
	label.text = text
	label.textColor = UIColor(named: "grayLightUniversal")
	label.font = UIFont(name: font, size: 14)
	label.numberOfLines = 0
	label.textAlignment = .center
	label.translatesAutoresizingMaskIntoConstraints = false
	return label
}


