//
//  RSSGenerator.swift
//  SilverFox-gen
//
//  Created by Louis D'hauwe on 28/05/2017.
//
//

import Foundation

func generateRSS(for articles: [Article]) -> String {
	
	let xmlDoc = XMLDocument()
	xmlDoc.version = "1.0"
	
	let rssNode = XMLElement(name: "rss")
	let attr = XMLNode(kind: .attribute)
	attr.name = "version"
	attr.objectValue = "2.0"
	rssNode.addAttribute(attr)
	
	xmlDoc.addChild(rssNode)
	
	let channelNode = XMLElement(name: "channel")
	rssNode.addChild(channelNode)
	
	let channelTitleNode = XMLElement(name: "title", stringValue: "Silver Fox Blog")
	channelNode.addChild(channelTitleNode)

	let channelLinkNode = XMLElement(name: "link", stringValue: "https://silverfox.be/blog/")
	channelNode.addChild(channelLinkNode)
	
	let channelDescriptionNode = XMLElement(name: "description", stringValue: "A place where I share interesting findings, new projects and just random thoughts. Kinda like my Twitter feed, but without a character limit.")
	channelNode.addChild(channelDescriptionNode)

	for article in articles {
		
		let articleNode = XMLElement(name: "item")
		
		let titleNode = XMLElement(name: "title", stringValue: article.metadata.title)
		articleNode.addChild(titleNode)
		
		let linkNode = XMLElement(name: "link", stringValue: "https://silverfox.be/blog/\(article.fileName)")
		articleNode.addChild(linkNode)
		
		let descriptionNode = XMLElement(name: "description", stringValue: article.metadata.excerpt)
		articleNode.addChild(descriptionNode)
		
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZ"
		
		let pubDateNode = XMLElement(name: "pubDate", stringValue: dateFormatter.string(from: article.metadata.date))
		articleNode.addChild(pubDateNode)
		
		channelNode.addChild(articleNode)
	}
	
	return xmlDoc.xmlString
}
