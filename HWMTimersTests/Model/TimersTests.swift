//
//  TimersTests.swift
//  HWMTimersTests
//
//  Created by Ant Gardiner on 5/09/23.
//

import XCTest
@testable import HWMTimers

final class TimersTests: XCTestCase {
	
	override func setUpWithError() throws {
	}
	
	override func tearDownWithError() throws {
	}
	
	func testDefaults() throws {
		
		let timers = AGTimers()
		
		let defaultTimers = timers.defaultTimers
		
		XCTAssertEqual(defaultTimers.count, 12)
	}

	func testDirectory() throws {
		
		let timers = AGTimers()
		XCTAssertTrue(timers.filePath.pathExtension == "json")
		XCTAssertTrue(timers.filePath.lastPathComponent == "homeworld-mobile-timers.json")
		XCTAssertTrue(timers.filePath.path().contains("Documents"))
	}
	
	func testLoadFileEmpty() async throws {

		let timers = AGTimers()

		do {
			try await timers.loadTimers()
			XCTFail("Should throw error if not exists.")
		}
		catch {
			let error = error as NSError
			XCTAssertEqual(error.code, 260)
		}
	}
	
	func testSaveLoadDeleteFileEmpty() async throws {
		
		let timers = AGTimers()
		
		XCTAssertFalse(FileManager.default.fileExists(atPath: timers.filePath.path()))
		
		timers.timers = timers.defaultTimers
		do {
			try await timers.saveTimers()
		}
		catch {
			XCTFail("Save failed \(error)")
		}
		
		let loadTimers = AGTimers()
			
		do {
			try await loadTimers.loadTimers()
		}
		catch {
			XCTFail("Load failed \(error)")
		}
		
		XCTAssertEqual(timers.timers, loadTimers.timers)
		
		do {
			try timers.deleteTimerFile()
		}
		catch {
			XCTFail("Delete file failed \(error)")
		}
	}
}
