//
//  SDU_AppTests.swift
//  SDU_AppTests
//
//  Created by Nurkhat on 30.08.2024.
//

import XCTest
import UserNotifications
@testable import SDU_App

final class SDU_AppTests: XCTestCase {
    var sut: SDU_App!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = SDU_App()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testRequestNotificationPermission() {
        let expectation = self.expectation(description: "Request notification permission")
        
        sut.requestNotificationPermission()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                XCTAssertTrue(settings.authorizationStatus == .authorized || settings.authorizationStatus == .notDetermined)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testCurrentWeekday() {
        let weekday = sut.currentWeekday()
        let validWeekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        XCTAssertTrue(validWeekdays.contains(weekday), "Current weekday should be a valid day of the week")
    }

    func testScheduleNotification() {
        let course = CourseNtfy(day: "Monday", startTime: "10:00", name: "Test Course", location: "Room 101")
        let date = Date().addingTimeInterval(60 * 60) // 1 hour from now
        
        sut.scheduleNotification(for: course, at: date)
        
        let expectation = self.expectation(description: "Schedule notification")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                XCTAssertTrue(requests.contains { $0.content.title == "Test Course" })
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetDateFromTime() {
        let time = "14:30"
        if let date = sut.getDateFromTime(time: time) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: date)
            XCTAssertEqual(components.hour, 14)
            XCTAssertEqual(components.minute, 30)
        } else {
            XCTFail("Failed to get date from time")
        }
    }

    func testSetupNotifications() {
        let courses = [
            CourseNtfy(day: sut.currentWeekday(), startTime: "10:00", name: "Today's Course", location: "Room 101"),
            CourseNtfy(day: "AnotherDay", startTime: "11:00", name: "Another Course", location: "Room 102")
        ]
        
        sut.setupNotifications(for: courses)
        
        let expectation = self.expectation(description: "Setup notifications")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                XCTAssertTrue(requests.contains { $0.content.title == "Today's Course" })
                XCTAssertFalse(requests.contains { $0.content.title == "Another Course" })
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
