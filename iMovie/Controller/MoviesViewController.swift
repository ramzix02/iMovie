
import UIKit
import BTNavigationDropdownMenu

class MoviesViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnMenue: UIBarButtonItem!
    private let networkingClient = NetworkingClient()
    var arr : [Movie]?
    
    var SV : ViewController?
    let items = ["Most Popular", "Top Rated"]
    var menuView : BTNavigationDropdownMenu?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        SV = (self.storyboard?.instantiateViewController(withIdentifier: "sec") as! ViewController)
       // arr = []
        
        if(ReachabilityNetwork.getReachabilityInfo())
        {
            SavedCoreDataHandler.fetchCoreDataFucn()
            SavedCoreDataHandler.deleteCoreDataFucn()
            networkFucn(strUrl: "https://api.themoviedb.org/3/discover/movie?api_key=61719a042a2b3abfbe5c5e2588b4e408")
            
           // print("2")
//            for item in arr!{
//                print("1")
//                SavedCoreDataHandler.saveCoreDataFucn(modelObj: item)
//            }
            
        }else{
            arr = SavedCoreDataHandler.fetchCoreDataFucn()
            ToastMSG.showToast(message: "No Internet!", VC: self)
        }
        
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: items.first!, items: items)
        self.btnMenue.customView = menuView
        menuView!.cellBackgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        
        menuView?.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            if indexPath == 0 {
                self?.networkFucn(strUrl: "https://api.themoviedb.org/3/discover/movie?api_key=61719a042a2b3abfbe5c5e2588b4e408")
            } else if indexPath == 1{
                self!.networkFucn(strUrl: "https://api.themoviedb.org/3/discover/movie?sort_by=vote_count.desc&api_key=61719a042a2b3abfbe5c5e2588b4e408")
                
            }
        }
    }
    
    @IBAction func btnMenueClick(_ sender: Any) {
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    
    func networkFucn( strUrl : String ) -> Void {
       // SavedCoreDataHandler.deleteCoreDataFucn()
            guard let urlToExcute = URL(string: strUrl) else{return}
            arr = []
            networkingClient.excute(urlToExcute) {(json , error) in
                if let error = error {
                    print(error)
                } else if let json = json {
                    let myJson = json["results"] as? [[String:Any]]
                    
                    for i in 0..<myJson!.count{
                        var obj:Movie?
                        obj=Movie()
                        obj?.title=myJson![i]["title"] as! String
                        obj?.image=myJson![i]["poster_path"] as! String
                        obj?.popularity=myJson![i]["popularity"] as! Double
                        obj?.voteCount=myJson![i]["vote_count"] as! Int
                        obj?.video=myJson![i]["video"] as! Bool
                        obj?.id=myJson![i]["id"] as! Int
                        obj?.adult=myJson![i]["adult"] as! Bool
                        obj?.originalLanguage=myJson![i]["original_language"] as! String
                        obj?.gener=myJson![i]["genre_ids"] as! [Int]
                        obj?.voteAvg = myJson![i]["vote_average"] as! NSNumber
                        obj?.overView = myJson![i]["overview"] as! String
                        obj?.releaseDate = myJson![i]["release_date"] as! String
                        
                        SavedCoreDataHandler.saveCoreDataFucn(modelObj: obj!)
                        
                        self.arr?.append(obj!)
                        
                    }
                    
                }else {
                    print("error")
                    
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }

        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (arr?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        var url2 = URL(string :"https://image.tmdb.org/t/p/w185/\(arr![indexPath.row].image)")
        cell.imgView?.sd_setImage(with: url2, completed: nil)
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SV?.objMovie = arr![indexPath.row]
        self.navigationController?.pushViewController(SV!, animated: true)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        return CGSize(width: width/2, height: height/2.3)
    }

}

