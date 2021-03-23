//
//  FirebirdError.swift
//  
//
//  Created by Ugo Cottin on 23/03/2021.
//

/// Describe an error that occur while operating with the database
public struct FirebirdError: Error {
	
	/// Generate a status array for C firebird functions calls
	public static var statusArray: Array<ISC_STATUS> {
		Array(repeating: 0, count: Int(ISC_STATUS_LENGTH))
	}
	
	/// Error code of the error
	public let errorCode: Int
	
	/// Associated sql error code
	public let sqlCode: Int32
	
	/// Reason of the error
	public var reason: String {
		let bufferSize = 512 // maximum size: 2^15
		var buffer: [Int8] = Array(repeating: 0, count: bufferSize)
		isc_sql_interprete(Int16(self.errorCode), &buffer, Int16(bufferSize))
		
		return String(cString: buffer)
	}
	
	/// Create a error from a status array used by a C firebird function call
	/// - Parameter array: the status array
	public init(from array: [ISC_STATUS]) {
		self.errorCode = array[1]
		
		self.sqlCode = withUnsafePointer(to: array[0]) { pointer in
			isc_sqlcode(UnsafeMutablePointer(mutating: pointer))
		}
	}
	
}

extension FirebirdError: CustomStringConvertible {
	public var description: String {
		"Firebird error \(self.errorCode), sqlcode \(self.sqlCode)"
	}
}

public struct FirebirdCustomError: Error {
	
	public let cursomDescription: String
	
	public init(_ description: String) {
		self.cursomDescription = description
	}
}

extension FirebirdCustomError: CustomStringConvertible {
	public var description: String {
		"Firebird error: \(self.cursomDescription)"
	}
}
