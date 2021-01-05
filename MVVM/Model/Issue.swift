

import Foundation

struct Issue : Codable {
    let title : String
    let comments_url : String
    let comments : Int
    let body : String
    let updated_at : String
    let number : Int
    
}
