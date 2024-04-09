import UIKit

class LeaderShipBoardVC: UIViewController {

    @IBOutlet weak var rankTable: UITableView!
    
    var highScores: [TopScore] = []

    override func viewDidLoad() {
        super.viewDidLoad()
       
        customizeNavigationBar(title: "Leadership Board")
        
        rankTable.delegate = self
        rankTable.dataSource = self
        
        let rankNib = UINib(nibName: "RankedUserList", bundle: nil)
        rankTable.register(rankNib, forCellReuseIdentifier: "RankedUserList")
        
        fetchDataFromAPI()
    }
    
    func fetchDataFromAPI() {
        guard let url = URL(string: "\(ServiceAPI.baseURL)leaderboard.php") else {
            print("Invalid URL.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Request error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response or status code not 200.")
                return
            }
            
            guard let data = data else {
                print("No data returned from the server.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let leaderboardResponse = try decoder.decode(Leaderboard.self, from: data)
                
                DispatchQueue.main.async {
                    self.highScores = leaderboardResponse.topScores
                    self.rankTable.reloadData()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }

}

extension LeaderShipBoardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rankCell = tableView.dequeueReusableCell(withIdentifier: "RankedUserList", for: indexPath) as? RankedUserList else {
            return UITableViewCell()
        }
        
        let player = highScores[indexPath.row]
        rankCell.namelabel?.text = player.name
        rankCell.scoreLabel?.text = "\(player.totalscore)"
        rankCell.loadImage(from: player.profileImage) 
        
        return rankCell
    }
}
