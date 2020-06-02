
import UIKit
import SDWebImage
import Cosmos
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let networkingClient = NetworkingClient()
    var myId : Int?
    var newArr : [ReviewModel]?
    var reviewFlag = false
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTest: UILabel!
    
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var txtView: UITextView!
    
    var objMovie: Movie = Movie()
    var SV : TableViewController?
    
    var fetchMovies = [NSManagedObject]()
    var flag = false
    
    var movies = [Movie]()
    
    var arr : [TrailerModel]?
    var deletedIndex : Int = 0
    
    //private let networkingClient = NetworkingClient()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SV = (self.storyboard?.instantiateViewController(withIdentifier: "sec1") as! TableViewController)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    @IBAction func btnReviews(_ sender: Any) {
        SV?.myId = objMovie.id
        self.navigationController?.pushViewController(SV!, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        let id : String = (objMovie.id as NSNumber).stringValue
        print(id)
        newNetworkFucn( strUrl : "https://api.themoviedb.org/3/movie/\(id)/reviews?api_key=61719a042a2b3abfbe5c5e2588b4e408&language=en-US&page=1")
        
        lblTest.text = objMovie.title
        lblYear.text = objMovie.releaseDate
        
        cosmosView.settings.fillMode = .precise
        
        let myRate = (Double((objMovie.voteAvg))/2)
        cosmosView.rating = myRate
        cosmosView.settings.updateOnTouch = false
        
        txtView.text = objMovie.overView
        var url = URL(string :"https://image.tmdb.org/t/p/w185/\(objMovie.image)")
        imgView.sd_setImage(with: url, completed: nil)
        
        movies = FavouritesCoreDataHandler.fetchCoreDataFucn()
        if (isFavourite()){
           btnFavourite.setImage(UIImage(named: "filledHeart.png"), for: .normal)
        }else{
        btnFavourite.setImage(UIImage(named: "emptyHeart.png"), for: .normal)
        }

        networkFucn( strUrl : "https://api.themoviedb.org/3/movie/\(objMovie.id)/videos?api_key=61719a042a2b3abfbe5c5e2588b4e408")
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
                    var obj:TrailerModel?
                    obj=TrailerModel()
                    obj?.name=myJson![i]["name"] as! String
                    obj?.key=myJson![i]["key"] as! String
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

    
    @IBAction func btnFavourite(_ sender: Any) {
        
        if(isFavourite())
        {
            ToastMSG.showToast(message : "Item Deleted!"  , VC : self)
            btnFavourite.setImage(UIImage(named: "emptyHeart.png"), for: .normal)
            FavouritesCoreDataHandler.deleteCoreDataFucn(deletedMovie: objMovie)
        }else{
            FavouritesCoreDataHandler.saveCoreDataFucn(modelObj: objMovie)
            ToastMSG.showToast(message : "Item Added!"  , VC : self)
            btnFavourite.setImage(UIImage(named: "filledHeart.png"), for: .normal)
        }
        movies = FavouritesCoreDataHandler.fetchCoreDataFucn()
    }
   
    func isFavourite() -> Bool{
        for movie in movies
        {
            if(movie.id == objMovie.id) {
                return true
        }
    }
        return false
    }
    
    func newNetworkFucn( strUrl : String ) -> Void {
        guard let urlToExcute = URL(string: strUrl) else{return}
        newArr = []
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
                    obj?.content=myJson![i]["content"] as! String
                    //print(obj?.author)
                    self.newArr?.append(obj!)
                    
                }
            }else {
                print("error")
                
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }
}




extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(newArr!.count != 0){
            reviewFlag = false
            return (newArr?.count)!
        }else{
            reviewFlag = true
             return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        if(!reviewFlag){
        cell.lblName.text = newArr![indexPath.row].author
        cell.txtView.text = newArr![indexPath.row].content
        }else{
            cell.lblName.text = ""
            cell.txtView.text = "Sorry , here is no available reviewes for that movie right now!"
        }
        return cell
    }
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arr?.count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = arr![indexPath.row].name
        cell.imageView?.image = #imageLiteral(resourceName: "you")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myUrl = URL(string: "https://www.youtube.com/watch?v=\(arr![indexPath.row].key)")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(myUrl!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(myUrl!)
        }
    }
}
