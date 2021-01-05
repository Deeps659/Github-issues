

import UIKit

class IssueViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var issuesViewModel = IssueViewModel()
    let helper = Helper()
    var cachedIssues : [Issue]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "IssueTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        loadData()
    }

    func updateUI() {
        tableView.reloadData()
    }
    
    func loadData() {
        let currentTime = Int(Date().timeIntervalSince1970 * 1000)
        let lastFetchTime = UserDefaults.standard.integer(forKey: "fetchTime")
        let diffInSec = (currentTime - lastFetchTime)/1000
        if (diffInSec/60) > 24*60 {
            issuesViewModel.fetchIssues{ [weak self] issues in
                self?.issuesViewModel.fetchComments(for: self?.getIssueNumbers(issueArr: self?.issuesViewModel.issues ?? []) ?? []) {[weak self] issueDetail in
                    DispatchQueue.main.async {
                        self?.updateUI()
                    }
                }
            }
        } else {
            //get cached data
            guard let issueData = UserDefaults.standard.object(forKey: "issuesData") as? Data else {
                return
            }
            guard let issuesArr = try? PropertyListDecoder().decode([Issue].self, from: issueData) else {
                return
            }
            issuesViewModel.issues = issuesArr
            
            guard let issueDetailData = UserDefaults.standard.object(forKey: "issuesDetailData") as? Data else {
                return
            }
            guard let issuesDetailDict = try? PropertyListDecoder().decode([Int:[Comment]].self, from: issueDetailData) else {
                return
            }
            issuesViewModel.issueDetail = issuesDetailDict
            
        }
    }
    
    func getIssueNumbers(issueArr : [Issue]) -> [Int] {
        let newArrUsingMap = issueArr.map { $0.number }
        return newArrUsingMap
    }

}

extension IssueViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let issue = issuesViewModel.issues[indexPath.row]
        if (issue.comments != 0) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "issueDetailController") as? IssueDetailViewController
            
            controller?.comments = issuesViewModel.issueDetail[issue.number] ?? []
            self.navigationController?.pushViewController(controller!, animated: true)
        } else {
            let alert = UIAlertController(title: "No comments", message: "No comments found for this issue",         preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension IssueViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issuesViewModel.issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? IssueTableViewCell
        
        let sortedIssues = issuesViewModel.issues.sorted { $0.updated_at >  $1.updated_at }
        let cellData = sortedIssues[indexPath.row]
        
        
        cell?.titleLabel?.text = cellData.title
        
        var mySubstring = String(cellData.body.prefix(140))
        mySubstring = mySubstring.elementsEqual("") ? "Issue description not available" : mySubstring
        cell?.bodyLabel?.text = mySubstring
        cell?.dateLabel?.text = helper.formatDate(date: cellData.updated_at)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}

