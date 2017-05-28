//
//  main.swift
//  SilverFox-gen
//
//  Created by Louis D'hauwe on 23/05/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import Files

func runtimeError(_ message: String) -> Never {
	print("❌ \(message)")
	exit(0)
}

let arguments = CommandLine.arguments
print(arguments)

print(Date())
print("Starting HTML generating 🚀 ...")


let rootFolder = try Folder(path: "~/projects/oss/silverfox-gen")



let articleHead = try rootFolder.file(atPath: "components/article-head.html").readAsString()
let articleFoot = try rootFolder.file(atPath: "components/article-foot.html").readAsString()

let blogHead = try rootFolder.file(atPath: "components/blog-head.html").readAsString()
let blogFoot = try rootFolder.file(atPath: "components/blog-foot.html").readAsString()

let newsHead = try rootFolder.file(atPath: "components/news-head.html").readAsString()
let newsFoot = try rootFolder.file(atPath: "components/news-foot.html").readAsString()

let postsFolder = try Folder(path: "~/projects/oss/silverfox-articles")
let newsFolder = try Folder(path: "~/projects/oss/silverfox-news")

//try rootFolder.createSubfolderIfNeeded(withName: "output")

let outputRoot = try Folder(path: "~/projects/oss/silverfox-site")
let articlesOutputFolder = try outputRoot.subfolder(named: "articles")

for file in articlesOutputFolder.files {
	try file.delete()
}

var articles = [Article]()

for file in postsFolder.files {
	
	let article = try Article(file: file)
	articles.append(article)
	
	guard let data = article.content.data(using: .utf8) else {
		runtimeError("Could not generate HTML data for \(file.nameExcludingExtension)")
	}
	
	try articlesOutputFolder.createFile(named: article.fileName, contents: data)
	
	print("✅ Successfully generated \(article.fileName)")
	
}

articles.sort { (a1, a2) -> Bool in
	a1.metadata.date > a2.metadata.date
}

let homeArticles = articles.prefix(2)

let homeArticlesHtml = homeArticles.map({ $0.tileHtml }).joined(separator: "\n")

print(homeArticlesHtml)


var newsItems = [NewsItem]()

for file in newsFolder.files {
	
	guard let newsItem = try NewsItem(file: file) else {
		runtimeError("Could not read news item for \(file.nameExcludingExtension)")
	}
	
	newsItems.append(newsItem)
}

newsItems.sort { (n1, n2) -> Bool in
	n1.date > n2.date
}

let homeNewsItems = newsItems.prefix(2)

let homeNewsItemsHtml = homeNewsItems.map({ $0.tileHtml }).joined(separator: "\n")

print(homeNewsItemsHtml)



let blogPage = blogHead + articles.map({ $0.tileHtml }).joined(separator: "\n") + blogFoot

guard let blogPageData = blogPage.data(using: .utf8) else {
	runtimeError("Could not generate html page for blog.html")
}

try outputRoot.createFile(named: "blog.html", contents: blogPageData)



let newsPage = newsHead + newsItems.map({ $0.tileHtml }).joined(separator: "\n") + newsFoot

guard let newsPageData = newsPage.data(using: .utf8) else {
	runtimeError("Could not generate html page for news.html")
}

try outputRoot.createFile(named: "news.html", contents: newsPageData)

let rssFile = try outputRoot.file(atPath: "silverfox-rss.xml")

try? rssFile.delete()

let rssString = generateRSS(for: articles)

try rssFile.write(string: rssString)

print("🌈 All done!")
print(Date())

