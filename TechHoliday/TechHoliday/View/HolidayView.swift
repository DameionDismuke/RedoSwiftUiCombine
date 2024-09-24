//
//  HolidayView.swift
//  ReviewPractice9162024SwiftUI
//
//  Created by Consultant on 9/16/24.
//

import SwiftUI

struct HolidayView: View {
    @StateObject private var viewModel = HolidaysViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search by title", text: $viewModel.searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                if viewModel.filtereDays.isEmpty {
                    Text("No holidays found.")
                        .padding()
                } else {
                    List(viewModel.filtereDays) { holiday in
                        NavigationLink(destination: HolidetailView(holiday: holiday)) {
                            VStack(alignment: .leading) {
                                Text(holiday.localName)
                                    .font(.headline)
                                Text(holiday.date)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .navigationTitle("Holidays")
                    .onAppear {
                        viewModel.fetchHolidays()
                    }
                }
            }
        }
        //        .onAppear {
        //            viewModel.fetchHolidays()
        //        }
    }
}
#Preview {
    HolidayView()
}
