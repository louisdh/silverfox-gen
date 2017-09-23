//
//  Errors.swift
//  SilverFox-gen
//
//  Created by Louis D'hauwe on 23/09/2017.
//

import Foundation

func runtimeError(_ message: String) -> Never {
	print("❌ \(message)")
	exit(0)
}
