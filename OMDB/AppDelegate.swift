//
//  AppDelegate.swift
//  OMDB
//
//  Created by Gautham Kumar on 16/04/17.
//  Copyright © 2017 Gautham Kumar. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovie")
        do {
            
            //Fetching all movies from core data
            storedMovies = try managedContext.fetch(fetchRequest)
            for item in storedMovies {
                
                let itemID = item.value(forKey: "imdbid") as! String
                let itemActors = item.value(forKey: "actors") as! String
                let itemDirector = item.value(forKey: "director") as! String
                let itemGenre = item.value(forKey: "genre") as! String
                let itemRating = item.value(forKey: "imdbrating") as! String
                let itemPlot = item.value(forKey: "plot") as! String
                let itemRel = item.value(forKey: "released") as! String
                let itemRun = item.value(forKey: "runtime") as! String
                let itemTitle = item.value(forKey: "title") as! String
                let itemPoster = item.value(forKey: "poster") as! String
                let itemPosterData = item.value(forKey: "posterdata") as! NSData
                
                //Creating dictionary from obtained data
                let movieDetails = ["Actors": itemActors, "Director": itemDirector, "Genre": itemGenre, "imdbRating": itemRating, "Plot": itemPlot, "Released": itemRel, "Runtime": itemRun, "Title": itemTitle, "imdbID": itemID, "Poster": itemPoster, "posterData": itemPosterData] as [String : Any]
                
                //Saving in favorite movies
                favoriteMovies[itemID] = movieDetails
                
                //Update favorite movie keys
                favoriteMovieKeys = Array(favoriteMovies.keys)
                print(favoriteMovies[itemID])
                
            }
        }
        catch let error as NSError {
            print("Error fetching : \(error)")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.

        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appdelegate.persistentContainer.viewContext
        
        //Delete old data
        for item in storedMovies {
            managedContext.delete(item)
            do {
                try managedContext.save()
            }
            catch let error as NSError {
                print("Error deleting : \(error)")
            }
        }
        
        //Store the favorite movie details
        for item in favoriteMovies {
            
            let entity = NSEntityDescription.entity(forEntityName: "FavoriteMovie", in: managedContext)!
            let movie = NSManagedObject(entity: entity, insertInto: managedContext)
            
            movie.setValue(item.value["imdbID"], forKey: "imdbid")
            movie.setValue(item.value["Actors"], forKey: "actors")
            movie.setValue(item.value["Director"], forKey: "director")
            movie.setValue(item.value["Genre"], forKey: "genre")
            movie.setValue(item.value["imdbRating"], forKey: "imdbrating")
            movie.setValue(item.value["Plot"], forKey: "Plot")
            movie.setValue(item.value["Released"], forKey: "released")
            movie.setValue(item.value["Runtime"], forKey: "runtime")
            movie.setValue(item.value["Title"], forKey: "title")
            movie.setValue(item.value["Poster"], forKey: "poster")
            movie.setValue(item.value["posterData"], forKey: "posterdata")
            
            do {
                try managedContext.save()
            }
            catch let error as NSError {
                print("Error saving into core data : \(error)")
            }
            
            self.saveContext()
        }
        
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "OMDB")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

