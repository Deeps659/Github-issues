

import Foundation

struct Comment : Codable {
    let user : UserData
    let body : String
}

struct UserData : Codable {
    let login : String
}
