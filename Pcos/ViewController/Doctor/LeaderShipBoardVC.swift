import UIKit

class LeaderShipBoardVC: UIViewController {

    @IBOutlet weak var rankTable: UITableView! {
        didSet {
            rankTable.delegate = self
            rankTable.dataSource = self
        }
    }
    
    var highScores: [TopScore] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar(title: "Leadership Board")
        let rankNib = UINib(nibName: "RankedUserList", bundle: nil)
        rankTable.register(rankNib, forCellReuseIdentifier: "RankedUserList")
        
        fetchDataFromAPI()
    }
    
    func fetchDataFromAPI() {
        guard let url = URL(string: "\(ServiceAPI.baseURL)leaderboard.php") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let leaderboardResponse = try decoder.decode(leaderboard.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.highScores = leaderboardResponse.topScores ?? []
                        self.rankTable.reloadData()
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
}

extension LeaderShipBoardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rankCell = rankTable.dequeueReusableCell(withIdentifier: "RankedUserList", for: indexPath) as! RankedUserList
        let player = highScores[indexPath.row]
        rankCell.namelabel?.text = player.name
        rankCell.scoreLabel?.text = "\(player.totalscore ?? 0)"  // Assuming a default value of 0 if totalscore is nil
        return rankCell
    }
}
