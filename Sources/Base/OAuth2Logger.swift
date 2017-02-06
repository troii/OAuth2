//
//  OAuth2Logger.swift
//  OAuth2
//
//  Created by Pascal Pfiffner on 05/05/16.
//  Copyright © 2016 Pascal Pfiffner. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import CocoaLumberjack

/**
Logging levels
*/
public enum OAuth2LogLevel: Int, CustomStringConvertible {
	
	/// If you want the logger to log everything.
	case trace = 0
	
	/// Only log debug messages.
	case debug
	
	/// Only warning messages.
	case warn
	
	/// Don't log anything.
	case off
	
	public var description: String {
		switch self {
		case .trace:
			return "Trace"
		case .debug:
			return "Debug"
		case .warn:
			return "Warn!"
		case .off:
			return "-/-"
		}
	}
}

extension OAuth2LogLevel: Comparable {
	
	static public func <(lh: OAuth2LogLevel, rh: OAuth2LogLevel) -> Bool {
		return lh.rawValue < rh.rawValue
	}
}


/**
A simple protocol for loggers used in OAuth2.

The `OAuth2DebugLogger` is a simple implementation that logs to stdout. If you need more sophisticated logging, just adapt this protocol
and set your logger on the `OAuth2` instance you're using.
*/
public protocol OAuth2Logger {
	
	/// The logger's logging level.
	var level: OAuth2LogLevel { get }
	
	/** Log a message at the trace level. */
	func trace(_ module: String?, filename: String?, line: Int?, function: String?, msg: @autoclosure() -> String)
	
	/** Standard debug logging. */
	func debug(_ module: String?, filename: String?, line: Int?, function: String?, msg: @autoclosure() -> String)
	
	/** Log warning messages. */
	func warn(_ module: String?, filename: String?, line: Int?, function: String?, msg: @autoclosure() -> String)
}

extension OAuth2Logger {
	
	/**
	The main log method, figures out whether to log the given message based on the receiver's logging level, then just uses `print`. Ignores
	filename, line and function.
	*/
	public func log(_ atLevel: OAuth2LogLevel, module: String?, filename: String?, line: Int?, function: String?, msg: @autoclosure() -> String) {
		if level != .off && atLevel.rawValue >= level.rawValue {
			print("[\(atLevel)] \(module ?? ""): \(msg())")
		}
	}
	
	/** Log a message at the trace level. */
	public func trace(_ module: String? = "OAuth2", filename: String? = #file, line: Int? = #line, function: String? = #function, msg: @autoclosure() -> String) {
		DDLogDebug("\(module ?? ""): \(msg())")
	}
	
	/** Standard debug logging. */
	public func debug(_ module: String? = "OAuth2", filename: String? = #file, line: Int? = #line, function: String? = #function, msg: @autoclosure() -> String) {
		DDLogDebug("\(module ?? ""): \(msg())")
    }
	
	/** Log warning messages. */
	public func warn(_ module: String? = "OAuth2", filename: String? = #file, line: Int? = #line, function: String? = #function, msg: @autoclosure() -> String) {
		DDLogWarn("\(module ?? ""): \(msg())")
	}
}


/**
Basic logger that just prints to stdout.
*/
open class OAuth2DebugLogger: OAuth2Logger {
	
	/// The logger's logging level, set to `Debug` by default.
	open var level = OAuth2LogLevel.debug
	
	
	/** Designated initializer. */
	public init(_ level: OAuth2LogLevel = OAuth2LogLevel.debug) {
		self.level = level
	}
}

