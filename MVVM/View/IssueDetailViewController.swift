

import UIKit

class IssueDetailViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var issuesViewModel = IssueViewModel()
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "IssueTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
    }
    
}

extension IssueDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? IssueTableViewCell
        let comment = comments[indexPath.row]
        cell?.titleLabel?.text = comment.user.login
        
        
        cell?.bodyLabel?.text = comment.body
        cell?.dateLabel?.text = ""
        cell?.accessoryType = .none
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
}
