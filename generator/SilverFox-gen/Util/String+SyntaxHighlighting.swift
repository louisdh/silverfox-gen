//
//  String+SyntaxHighlighting.swift
//  SilverFox-gen
//
//  Created by Louis D'hauwe on 28/05/2017.
//
//

import Foundation
import Files
import JavaScriptCore

extension String {
	
	var syntaxHighlightedHTMLAsSwift: String? {
		
		guard let prismJSFile = try? rootFolder.file(atPath: "generator/SilverFox-gen/js/prism.js") else {
			return nil
		}
		
		guard let prismJS = try? prismJSFile.readAsString() else {
			return nil
		}
		
		guard let jsContext = JSContext() else {
			return nil
		}
		
		// The code snippet you want to highlight, as a string
		jsContext.setObject(self, forKeyedSubscript: "code" as NSCopying & NSObjectProtocol)
		
		// Returns a highlighted HTML string
		let js2 = "\nvar html = Prism.highlight(code, Prism.languages.swift);"
		
		let js = prismJS + js2
		
		jsContext.evaluateScript(js)
		
		let highlightedHTML = jsContext.objectForKeyedSubscript("html")
		
		return highlightedHTML?.toString()
	}
	
}
