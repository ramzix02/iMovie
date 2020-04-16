import Foundation
import CoreData
import UIKit

class SavedCoreDataHandler{
    
    static var fetchMovies = [NSManagedObject]()

    static func saveCoreDataFucn( modelObj : Movie ) -> Void
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "SavedMovies", in: managedContext)
        
        let movie = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        movie.setValue(modelObj.voteAvg, forKey: "voteAvg")
        movie.setValue(modelObj.image, forKey: "image")
        movie.setValue(modelObj.title, forKey: "title")
        movie.setValue(modelObj.releaseDate, forKey: "releaseDate")
        movie.setValue(modelObj.overView, forKey: "overView")
        movie.setValue(modelObj.id, forKey: "id")
        //print("done Save")
        do{
            try managedContext.save()
        }catch{
            print(error)
        }
        
        print("done Save")
    }
    
    static func fetchCoreDataFucn( ) -> ([Movie])
    {
        var movies = [Movie]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedMovies")
        
        do{
            fetchMovies = try managedContext.fetch(fetchRequest)
            print("mazen")
            print(fetchMovies.count)
            for item in fetchMovies {
                //print(fetchMovies.count)
                let objNew = Movie()
                objNew.voteAvg = item.value(forKey: "voteAvg") as! NSNumber
                print("\(objNew.voteAvg)")
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
    
    static func deleteCoreDataFucn() -> Void
    {
        let appDelegation = UIApplication.shared.delegate as! AppDelegate
        
        let contextview = appDelegation.persistentContainer.viewContext
        
        for object in fetchMovies{
            print("deleted")
                contextview.delete(object)
            
        }
        
        
        
        do{
            try contextview.save()
        }catch{
            print(error)
        }
    }
}
