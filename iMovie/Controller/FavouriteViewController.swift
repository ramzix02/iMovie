import UIKit
import CoreData

class FavouriteViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collectionView: UICollectionView!
    var arr = [Movie]()
    var movies = [Movie]()
    var SV : ViewController?
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        return CGSize(width: width/2, height: height/2.3)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        SV = (self.storyboard?.instantiateViewController(withIdentifier: "sec") as! ViewController)
    }
    override func viewWillAppear(_ animated: Bool) {
        arr = fetchCoreDataFucn()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (arr.count)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        var url2 = URL(string :"https://image.tmdb.org/t/p/w185/\(arr[indexPath.row].image)")
        cell.imgView?.sd_setImage(with: url2, completed: nil)
        
        return cell
    }


    func fetchCoreDataFucn( ) -> ([Movie])
    {
        movies=[]
        var fetchMovies = [NSManagedObject]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movies")
        
        do{
            fetchMovies = try managedContext.fetch(fetchRequest)
            for item in fetchMovies {
                let objNew = Movie()
                objNew.voteAvg = item.value(forKey: "voteAvg") as! NSNumber
                objNew.image = item.value(forKey: "image") as! String
                objNew.title = item.value(forKey: "title") as! String
                objNew.releaseDate = item.value(forKey: "releaseDate") as! String
                objNew.overView = item.value(forKey: "overView") as! String
                objNew.id = item.value(forKey: "id") as! Int
                movies.append(objNew)
            }
        }catch let error as NSError{
            print(error)
        }
        
        return movies
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SV?.objMovie = arr[indexPath.row]
        self.navigationController?.pushViewController(SV!, animated: true)
    }

}
