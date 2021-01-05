

import Foundation

class Helper {
    
    func formatDate(date : String) -> String {
        //print(date)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var dateStr = ""
        if let yourDate = formatter.date(from: date) {
            //print(yourDate)
            formatter.dateFormat = "dd-MMM-yyyy HH:mm"
            dateStr = formatter.string(from: yourDate)
        }
        //print(dateStr)
        return dateStr
    }
    
    
    
}
