//
//  String+Substring.swift
//  SilverFox-gen
//
//  Created by Louis D'hauwe on 28/05/2017.
//
//

import Foundation

extension String {
	
	func slice(from: String, to: String) -> String? {
		
		return (range(of: from)?.upperBound).flatMap { substringFrom in
			(range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
				String(self[substringFrom..<substringTo])
			}
		}
	}
}

extension String {
	
	mutating func appendToFront(_ string: String) {
		self = string + self
	}
	
}
