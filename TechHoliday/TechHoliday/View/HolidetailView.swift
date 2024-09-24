//
//  HolidetailView.swift
//  ReviewPractice9162024SwiftUI
//
//  Created by Consultant on 9/16/24.
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
import SwiftUI

struct HolidetailView: View {
    let holiday: Holidays
    var body: some View {
        VStack {
            Text("date: \(holiday.date)")
            Text("name: \(holiday.name)")
            Text("countryCode: \(holiday.countryCode)")

            Text("fixed: \(holiday.fixed ? "Yes" : "No")")
            Text("global: \(holiday.global ? "Yes" : "No")")

//            Text("counties: \(holiday.counties)")
            if let counties = holiday.counties {
                Text("Counties: \(counties.joined(separator: ", "))")
            }
            
            if let launchYear = holiday.launchYear {
                Text("launchYear: \(launchYear)")
            }
//            Text("launchYear: \(holiday.launchYear)")

            Text("type: \(holiday.type)")
        }
        .padding()
        .navigationTitle(holiday.localName)
    }
}

#Preview {
    HolidetailView(holiday: Holidays(
        date: "12-04",
        localName: "Test Local Name",
        name: "Dameion Birthday",
        countryCode: "USA",
        fixed: true,
        global: true,
        counties: ["Georgia", "Florida", "Alabama"],
        launchYear: 1994,
        type: "Birthday"))
}
