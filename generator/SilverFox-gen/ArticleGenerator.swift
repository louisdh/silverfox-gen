//
//  ArticleGenerator.swift
//  SilverFox-gen
//
//  Created by Louis D'hauwe on 28/05/2017.
//
//

import Foundation
import SwiftMarkdown
import Files
import HTMLString

protocol HasDate {
	
	var date: Date { get }
	
}

extension HasDate {
	
	var formattedDate: String {
		let dateDisplayFormatter = DateFormatter()
		dateDisplayFormatter.timeStyle = .none
		dateDisplayFormatter.dateStyle = .full
		
		return dateDisplayFormatter.string(from: date)
	}
	
}

extension Article {

	var tileHtml: String {
		
		let relativeLink = "/articles/\(fileName)"
		let html = """
		<a href="\(relativeLink)">
			<div class="tile blog-post">
				<span class="blog-post-wrapper">
					<h3>\(metadata.title.addingUnicodeEntities)</h3>
					<p class="article-metadata-date">\(metadata.formattedDate.addingUnicodeEntities)</p>
					<span class="blog-post-excerpt">
						\(metadata.excerpt.addingUnicodeEntities)
					</span>
				</span>
				<div>
					<p>Read</p>
				</div>
			</div>
		</a>
		"""

		return html
	}
	
}

extension Article {
	
	init(file: File) throws {
		
		let fileName = file.name
		
		print("Starting \(fileName) generating ...")
		
		let dateFormat = "yyyy-MM-dd"
		
		guard fileName.count > dateFormat.count else {
			runtimeError("Invalid date format in \(file.name) file name, please provide in format: \"\(dateFormat)\"")
		}
		
		let dateEndIndex = fileName.index(fileName.startIndex, offsetBy: dateFormat.count)
		
		let dateString = String(fileName[..<dateEndIndex])
		
		let formatter = DateFormatter()
		formatter.dateFormat = dateFormat
		
		guard let date = formatter.date(from: dateString) else {
			runtimeError("Invalid date format in \(file.name) file name, please provide in format: \"\(dateFormat)\"")
		}
		
		var markdown = try file.readAsString()
		
		var html = ""
		
		guard markdown.hasPrefix("---") else {
			runtimeError("Make sure to add \"---\" info at the top of \(file.name)")
		}
		
		guard let infoSlice = markdown.slice(from: "---", to: "---") else {
			runtimeError("Make sure to add \"---\" info at the top of \(file.name)")
		}
		
		let origString = "---\(infoSlice)---"
		
		let articleInfos = infoSlice.components(separatedBy: "\n")
		
		guard let infoDict = articleInfos.dictionary(separatedBy: ": ") else {
			runtimeError("Could not initialize \(file.nameExcludingExtension)")
		}
		
		guard let metadata = ArticleMetadata(infoDict: infoDict, date: date) else {
			runtimeError("Could not initialize metadata for \(file.nameExcludingExtension)")
		}
		
		let formattedArticleDate = metadata.formattedDate
		
		markdown = markdown.replacingOccurrences(of: origString, with: "")
		
		let header = """
		<div align="center" class="article-metadata">
			<h1> \(metadata.title.addingUnicodeEntities)</h1>
			<p class="article-metadata-date">\(formattedArticleDate)</p>
			<p class="article-metadata-author">by \(metadata.author.addingUnicodeEntities)</p>
			<p class="article-metadata-tags">tags: \(metadata.tags.joined(separator: ", ").addingUnicodeEntities)</p>
		</div>\n
		"""
		
		markdown.appendToFront(header)
		
		while let slice = markdown.slice(from: "```swift", to: "```") {
			
			let origString = "```swift\(slice)```"
			
			guard let syntaxHighlighted = slice.syntaxHighlightedHTMLAsSwift else {
				runtimeError("Could not generate syntax highlighted string for \(file.nameExcludingExtension)")
			}
			
			var newString = "<code class=\"language-swift\">\(syntaxHighlighted)</code>"
			
			if origString.contains("\n") {
				newString = "<pre>\(newString)</pre>"
			}
			
			markdown = markdown.replacingOccurrences(of: origString, with: newString)
			
		}
		
		
		html = try markdownToHTML(markdown, options: [.hardBreaks, .normalize])
		
		html = articleHead + html + articleFoot
		
		html = html.replacingOccurrences(of: "{{title}}", with: metadata.title)
		html = html.replacingOccurrences(of: "{{description}}", with: metadata.excerpt)
		
		self.metadata = metadata
		self.content = html
		self.fileName = file.nameExcludingExtension + ".html"
	}
	
}
