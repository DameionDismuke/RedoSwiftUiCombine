//
//  HolidaysViewModel.swift
//  ReviewPractice9162024SwiftUI
//
//  Created by Consultant on 9/16/24.
//

import Foundation
import Combine

class HolidaysViewModel: ObservableObject {
    private var holidays: [Holidays] = []
    @Published var errorMessage: String = ""
    @Published var filtereDays: [Holidays] = []
    @Published var searchText: String = "" {
        didSet {
            applySearchFilter()
        }
    }
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        fetchHolidays()
        addDebounce()
    }

    func fetchHolidays() {
        networkService.fetchHolidays()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] holidays in
                self?.holidays = holidays
            })
            .store(in: &cancellables)
    }

    private func addDebounce() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applySearchFilter()
            }
            .store(in: &cancellables)
    }

    private func applySearchFilter() {
        if searchText.isEmpty {
            filtereDays = holidays
        } else {
            filtereDays = holidays.filter {
                $0.localName.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

#if DEBUG
extension HolidaysViewModel {
    var testHooks: TestHooks { .init(target: self) }
    
    class TestHooks {
        let target: HolidaysViewModel
        
        init(target: HolidaysViewModel) {
            self.target = target
        }
        
        var holidays: [Holidays] {
            get { target.holidays }
            set { target.holidays = newValue } 
        }
    }
}
#endif
