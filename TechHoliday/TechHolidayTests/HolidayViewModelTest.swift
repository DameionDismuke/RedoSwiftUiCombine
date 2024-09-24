//
//  HolidayViewModelTest.swift
//  ReviewPractice9162024SwiftUITests
//
//  Created by Consultant on 9/20/24.
//
//{
//    "date": "2024-01-01",
//    "localName": "New Year's Day",
//    "name": "New Year's Day",
//    "countryCode": "US",
//    "fixed": false,
//    "global": true,
//    "counties": null,
//    "launchYear": null,
//    "type": "0"
//  }
import XCTest
import Combine
@testable import TechHoliday

class HolidaysViewModelTests: XCTestCase {
    var viewModel: HolidaysViewModel!
    var mockNetworkService: MockNetworkService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = HolidaysViewModel(networkService: mockNetworkService)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // Test fetching
    func testFetchHolidays_success() {
        let expectedHolidays = [
            TechHoliday.Holidays(
                date: "2024-01-01",
                localName: "New Year's Day",
                name: "New Year's Day",
                countryCode: "US",
                fixed: true,
                global: true,
                counties: nil,
                launchYear: nil,
                type: "0")
        ]
        mockNetworkService.holidays = expectedHolidays
        viewModel.fetchHolidays()
        
        XCTAssertEqual(mockNetworkService.holidays, expectedHolidays)
        XCTAssertTrue(viewModel.errorMessage.isEmpty)
    }
    
    // Test search functionality
    func testSearchFiltering() {
        let holidays = [
            Holidays(
                date: "2024-01-01",
                localName: "New Year's Day",
                name: "New Year's Day",
                countryCode: "US",
                fixed: true,
                global: true,
                counties: nil,
                launchYear: nil,
                type: "Public"),
            Holidays(
                date: "2024-07-04",
                localName: "Independence Day",
                name: "Independence Day",
                countryCode: "US",
                fixed: true,
                global: true,
                counties: nil,
                launchYear: nil,
                type: "Public")
        ]
        viewModel.testHooks.holidays = holidays
        viewModel.searchText = "new"
        
        XCTAssertEqual(viewModel.filtereDays.count, 1)
        XCTAssertEqual(viewModel.filtereDays.first?.localName, "New Year's Day")
    }
    
    // Testing network error
    func testFetchHolidays_failure() {
        let expectation = self.expectation(description: "\(NetworkError.requestFailed)")
        
        mockNetworkService.shouldReturnError = true
        viewModel.fetchHolidays()
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                if !errorMessage.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertFalse(viewModel.errorMessage.isEmpty)
        XCTAssertTrue(mockNetworkService.holidays.isEmpty)
    }
}

class MockNetworkService: NetworkServiceProtocol {
    func fetchHolidays() -> AnyPublisher<[TechHoliday.Holidays], TechHoliday.NetworkError> {
        if shouldReturnError {
            return Fail(error: NetworkError.requestFailed)
                .eraseToAnyPublisher()
        } else {
            return Just(holidays)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
    }
    
    var shouldReturnError = false
    var holidays: [Holidays] = []
}
