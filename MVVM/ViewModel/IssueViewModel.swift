

import Foundation

class IssueViewModel {
    // MARK: - Initialization
    init(model: [Issue]? = nil) {
        if let inputModel = model {
            issues = inputModel
        }
    }
    var issues = [Issue]()
    var comments = [Comment]()
    var issueDetail = [Int:[Comment]]()
}

extension IssueViewModel {
    func fetchIssues(completion: @escaping (Result<[Issue], Error>) -> Void) {
        let currentTime = Int(Date().timeIntervalSince1970 * 1000)
        UserDefaults.standard.set(currentTime, forKey: "fetchTime")
        HTTPManager.shared.get(urlString: baseUrl, completionBlock: { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error):
                print ("failure", error)
            case .success(let dta) :
                let decoder = JSONDecoder()
                do
                {
                    self.issues = try decoder.decode([Issue].self, from: dta)
                    completion(.success(try decoder.decode([Issue].self, from: dta)))
                    
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(self.issues), forKey: "issuesData")
                
                } catch {
                    // deal with error from JSON decoding if used in production
                }
            }
        })
    }
    
    func fetchComments(for issues: [Int], completion: @escaping (Result<[Int:[Comment]], Error>) -> Void) {
        for issue in issues {
            HTTPManager.shared.get(urlString: baseUrl + "/" + String(issue) + commentsUrl, completionBlock: { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .failure(let error):
                    print ("failure", error)
                case .success(let dta) :
                    let decoder = JSONDecoder()
                    do
                    {
                        self.comments = try decoder.decode([Comment].self, from: dta)
                         self.issueDetail.updateValue(self.comments, forKey: issue)
                        completion(.success(self.issueDetail))
                        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.issueDetail), forKey: "issuesDetailData")
                    
                    } catch {
                        // deal with error from JSON decoding if used in production
                    }
                }
            })
        }
        
    }
    
    
}
