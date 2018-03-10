//
//  Array+Dictionary.swift
//  SilverFox-gen
//
//  Created by Louis D'hauwe on 28/05/2017.
//
//

import Foundation

extension Array where Element == String {
	
	func dictionary(separatedBy separator: String) -> [String : String]? {
		
		var dict = [String : String]()
		
		for e in self where !e.isEmpty {
			
			guard let key = e.components(separatedBy: separator).first else {
				return nil
			}
			
			let start = e.index(e.startIndex, offsetBy: key.count + separator.count)
			let value = String(e[start...])
			
			dict[key] = value
		}
		
		return dict
	}
	
}
