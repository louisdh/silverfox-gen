//
//  Article.swift
//  SilverFox-gen
//
//  Created by Louis D'hauwe on 28/05/2017.
//
//

import Foundation

struct Article {
	
	let metadata: ArticleMetadata
	let content: String
	let fileName: String
	
	init(metadata: ArticleMetadata, content: String, fileName: String) {
		self.metadata = metadata
		self.content = content
		self.fileName = fileName
	}
}

extension Article: Comparable {
	
	static func <(lhs: Article, rhs: Article) -> Bool {
		return lhs.metadata < rhs.metadata
	}
	
	static func ==(lhs: Article, rhs: Article) -> Bool {
		return lhs.metadata == rhs.metadata
	}
	
}
