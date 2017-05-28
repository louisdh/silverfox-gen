//
//  NewsItem.swift
//  SilverFox-gen
//
//  Created by Louis D'hauwe on 28/05/2017.
//
//

import Foundation

struct NewsItem: HasDate {
	
	let title: String
	let author: String
	let link: String
	
	// TODO: make enum
	let category: String
	
	let tags: [String]
	let date: Date
	
	init?(infoDict: [String : String], date: Date) {
		
		guard let title = infoDict["title"] else {
			return nil
		}
		
		guard let author = infoDict["author"] else {
			return nil
		}
		
		guard let link = infoDict["link"] else {
			return nil
		}		
		
		guard let category = infoDict["category"] else {
			return nil
		}
		
		guard let tags = infoDict["tags"]?.components(separatedBy: ", ") else {
			return nil
		}
		
		self.title = title
		self.author = author
		self.link = link
		
		self.category = category
		
		// Alphabetically sorted
		self.tags = tags.sorted(by: <)
		self.date = date
		
	}
	
}
