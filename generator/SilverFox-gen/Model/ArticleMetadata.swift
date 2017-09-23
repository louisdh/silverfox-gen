//
//  ArticleMetadata.swift
//  SilverFox-gen
//
//  Created by Louis D'hauwe on 28/05/2017.
//
//

import Foundation

struct ArticleMetadata: HasDate {
	
	let title: String
	let author: String
	let category: String
	let tags: [String]
	let excerpt: String
	let date: Date
	
	init?(infoDict: [String : String], date: Date) {
		
		guard let title = infoDict["title"] else {
			return nil
		}
		
		guard let author = infoDict["author"] else {
			return nil
		}
		
		guard let category = infoDict["category"] else {
			return nil
		}
		
		guard let tags = infoDict["tags"]?.components(separatedBy: ", ") else {
			return nil
		}
		
		guard let excerpt = infoDict["excerpt"] else {
			return nil
		}
		
		self.title = title
		self.author = author
		self.category = category
		
		// Alphabetically sorted
		self.tags = tags.sorted(by: <)
		self.excerpt = excerpt
		self.date = date
		
	}
	
}

extension ArticleMetadata: Comparable {
	
	static func <(lhs: ArticleMetadata, rhs: ArticleMetadata) -> Bool {
		return lhs.date < rhs.date || lhs.title < rhs.title
	}
	
	static func ==(lhs: ArticleMetadata, rhs: ArticleMetadata) -> Bool {
		return lhs.date == rhs.date
			&& lhs.author == rhs.author
			&& lhs.title == rhs.title
	}
	
}
