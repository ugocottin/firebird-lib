//
//  FirebirdDatabaseWithCustomLogger.swift
//  
//
//  Created by Ugo Cottin on 23/03/2022.
//

import Logging

internal struct FirebirdDatabaseWithCustomLogger {
	let database: FirebirdDatabase
	let logger: Logger
}

extension FirebirdDatabaseWithCustomLogger: FirebirdDatabase {
	func createStatement(_ query: String) -> FirebirdStatement {
		self.database.createStatement(query)
	}
	
	func execute(_ statement: FirebirdStatement, transaction: FirebirdTransaction, logger: Logger) throws -> FirebirdQueryResult {
		return try self.database.execute(statement, transaction: transaction, logger: logger)
	}
	
	func withConnection<T>(_ closure: (FirebirdConnection) throws -> T) rethrows -> T {
		try self.database.withConnection(closure)
	}
	
	// MARK: - Transaction
	var inTransaction: Bool {
		self.database.inTransaction
	}
	
	func startTransaction(parameters: FirebirdTransactionParameterBuffer) throws -> FirebirdDatabase {
		try self.database.startTransaction(parameters: parameters)
			.logging(to: self.logger)
	}
	
	func commitTransaction() throws -> FirebirdDatabase {
		try self.database.commitTransaction()
			.logging(to: self.logger)
	}
	
	func rollbackTransaction() throws -> FirebirdDatabase {
		try self.database.rollbackTransaction()
			.logging(to: self.logger)
	}
}
