//
//  DatabaseHelpers.swift
//  Receipt Gobbler
//
//  Created by Jiacheng Dong on 10/24/24.
//

import Foundation
import SQLite3

class DatabaseHelper{
    
    init(){
        database = openDatabase()
        createTables()
    }
    
    let databasePath = "ReceiptsMainDB.sqlite"
    var database:OpaquePointer?
    
    private func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(databasePath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("Failed connecting to database at \(databasePath) \n")
            return nil
        }
        else
        {
            print("Successfully connected to database at \(databasePath) \n")
            return db
        }
    }
    
    private func createTables() {
        let createTablesString = """
            CREATE TABLE IF NOT EXISTS
            Receipt (
            id INTEGER PRIMARY KEY,
            merchant_id INTEGER,
            merchant_name TEXT,
            total_cost REAL,
            time_purchased TEXT
            );
            
            CREATE TABLE IF NOT EXISTS
            Merchant (
            id INTEGER PRIMARY KEY,
            name TEXT
            address TEXT,
            phone_number TEXT UNIQUE
            );
            
            CREATE TABLE IF NOT EXISTS
            ItemReceipt (
            receipt_id INTEGER NOT NULL,
            item_id INTEGER NOT NULL,
            amount INTEGER NOT NULL,
            PRIMARY KEY (receipt_id, item_id)
            );
            
            CREATE TABLE IF NOT EXISTS
            Item (
            id INTEGER PRIMARY KEY,
            name TEXT,
            price INTEGER
            );
            
        """
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(database, createTablesString, -1, &createTableStatement, nil) ==
        SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Tables created. \n")
            } else {
                print("Failed to create tables. \n")
            }
        } else {
            print("Failed to compile create table statements. \n")
        }
        sqlite3_finalize(createTableStatement)

        
    }
    
    func insertReceipt (merchantName: String, totalPrice: Double, itemsNameAndUnitprice: [(itemName:String, unitPrice: Double)]){
        let insertReceiptString = """
            INSERT INTO Receipt (merchant_name, total_cost) VALUES (?, ?);
        """
        
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(database, insertReceiptString, -1, &insertStatement, nil) != SQLITE_OK {
            print("Failed to compile INSERT statement. \n")
            return
        }
        sqlite3_bind_text(insertStatement, 1, merchantName, -1, nil)
        sqlite3_bind_double(insertStatement, 2, totalPrice)
        if sqlite3_step(insertStatement) == SQLITE_DONE {
            print("Successfully inserted receipt. \n")
        } else {
            print("Failed to insert receipt. \n")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func insertItems(itemsNameAndUnitprice: [(itemName: String, unitPrice: Double)]) {
        let insertReceiptString = """
            INSERT INTO Item (name, price) VALUES (?, ?);
        """
        var insertReceiptStatement: OpaquePointer?
        if sqlite3_prepare_v2(database, insertReceiptString, -1, &insertReceiptStatement, nil) != SQLITE_OK {
            print("Failed to compile INSERT statement. ")
            return
        }
        for (name, unitPrice) in itemsNameAndUnitprice {
            sqlite3_bind_text(insertReceiptStatement, 2, name, -1, nil)
            sqlite3_bind_double(insertReceiptStatement, 1, unitPrice)
            if sqlite3_step(insertReceiptStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Failed to insert row.")
            }
            sqlite3_reset(insertReceiptStatement)
        }
        sqlite3_finalize(insertReceiptStatement)
        
    }
    
    func selectAllReceipts () -> [ReceiptSummary]{
        let queryStatementString = "SELECT * FROM Receipt;"
        var queryStatement: OpaquePointer? = nil
        var receiptSummaries : [ReceiptSummary] = []
        if sqlite3_prepare_v2(database, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let merchantName = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let totalCost = sqlite3_column_double(queryStatement,4)
                let datePurchsed = String(describing: String(cString: sqlite3_column_text(queryStatement, 5))) //needs to be converetd to Date object
//                receipts.append(ReceiptSummary())
            }
        } else {
            print("SELECT from Receipt statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return receiptSummaries
        
    }
    
    func deleteReceipt () {
        
    }
    
    func updateReceipt() {
        
    }
    
    func searchRecipt(){
        
    }
}
