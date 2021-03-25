//
//  FirebirdTests.swift
//  
//
//  Created by ugo cottin on 21/03/2021.
//

import XCTest
@testable import Firebird

final class FirebirdTests: XCTestCase {
	
	private let configuration = FirebirdConnectionConfiguration(
		hostname: "localhost",
		port: 3051,
		username: "SYSDBA",
		password: "MASTERKEY",
		database: "EMPLOYEE")
	
	private var connection: FirebirdConnection!
	
	override func setUpWithError() throws {
		self.connection = try FirebirdConnection.connect(configuration)
	}
	
	override func tearDownWithError() throws {
		try self.connection!.close()
	}
	
	func testConnect() throws {
		let configuration = FirebirdConnectionConfiguration(
			hostname: "localhost",
			port: 3051,
			username: "SYSDBA",
			password: "MASTERKEY",
			database: "EMPLOYEE")
		
		let connection = try FirebirdConnection.connect(configuration)
		try connection.close()
	}
	
	func testQuery() throws {
		self.measure {
			XCTAssertNoThrow {
				let rows = try self.connection.query("***REMOVED***")
				for row in rows {
					print(row.values)
				}
				try self.connection.close()
			}
		}
	}
	
	func testQueryEscaping() throws {
		self.measure {
			XCTAssertNoThrow {
				try self.connection.query("***REMOVED***") { row in
					print(row.values)
				}
				try self.connection.close()
			}
		}
	}

	static var allTests = [
		("testConnect", testConnect),
		("testQuery", testQuery),
		("testQueryEscaping", testQueryEscaping),
	]
}
