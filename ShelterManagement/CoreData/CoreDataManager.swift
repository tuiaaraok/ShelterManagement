//
//  CoreDataManager.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 28.11.24.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ShelterManagement")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveAnimal(animalModel: AnimalModel, completion: @escaping (Error?) -> Void) {
        let id = animalModel.id
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Animal> = Animal.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let animal: Animal
                
                if let existingAnimal = results.first {
                    animal = existingAnimal
                } else {
                    animal = Animal(context: backgroundContext)
                    animal.id = id
                }
                    
                animal.name = animalModel.name
                animal.type = animalModel.type
                animal.age = Int32(animalModel.age ?? 0)
                
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchAnimals(completion: @escaping ([AnimalModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Animal> = Animal.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var animalsModel: [AnimalModel] = []
                for result in results {
                    let animalModel = AnimalModel(id: result.id ?? UUID(), name: result.name, type: result.type, age: Int(result.age))
                    animalsModel.append(animalModel)
                }
                DispatchQueue.main.async {
                    completion(animalsModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func removeAnimal(by id: UUID, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Animal> = Animal.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let animalToDelete = results.first {
                    backgroundContext.delete(animalToDelete)
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func saveFeed(feedModel: FeedModel, completion: @escaping (Error?) -> Void) {
        let id = feedModel.id
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Feed> = Feed.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let feed: Feed
                
                if let existingFeed = results.first {
                    feed = existingFeed
                } else {
                    feed = Feed(context: backgroundContext)
                    feed.id = id
                }
                    
                feed.type = feedModel.type
                feed.quantity = feedModel.quantity ?? 0
                
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchFeeds(completion: @escaping ([FeedModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Feed> = Feed.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var feedsModel: [FeedModel] = []
                for result in results {
                    let feedModel = FeedModel(id: result.id ?? UUID(), type: result.type, quantity: result.quantity)
                    feedsModel.append(feedModel)
                }
                DispatchQueue.main.async {
                    completion(feedsModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }

}

