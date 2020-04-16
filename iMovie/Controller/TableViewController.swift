
import UIKit

class TableViewController: UITableViewController {
    private let networkingClient = NetworkingClient()
    var myId : Int?
    var arr : [ReviewModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    override func viewWillAppear(_ animated: Bool)
    {
        let id : String = (myId! as NSNumber).stringValue
        networkFucn( strUrl : "https://api.themoviedb.org/3/movie/\(id)/reviews?api_key=61719a042a2b3abfbe5c5e2588b4e408&language=en-US&page=1")
    }
    func networkFucn( strUrl : String ) -> Void {
        guard let urlToExcute = URL(string: strUrl) else{return}
        arr = []
        networkingClient.excute(urlToExcute) {(json , error) in
            if let error = error {
                print(error)
            } else if let json = json {
                let myJson = json["results"] as? [[String:Any]]
                
                for i in 0..<myJson!.count{
                    var obj:ReviewModel?
                    obj=ReviewModel()
                    obj?.author=myJson![i]["author"] as! String
                    obj?.url=myJson![i]["url"] as! String
                
                    self.arr?.append(obj!)
                    
                }
            }else {
                print("error")
                
            }
            DispatchQueue.main.async {
               self.tableView.reloadData()
            }
        }
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arr?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = arr?[indexPath.row].author
        cell.imageView?.image = #imageLiteral(resourceName: "reviews")
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myUrl = URL(string: arr![indexPath.row].url)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(myUrl!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(myUrl!)
            }
        }
    }







