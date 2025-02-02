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
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Feed> = Feed.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "type == %@", feedModel.type ?? "")
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let feed: Feed
                
                if let existingFeed = results.first {
                    feed = existingFeed
                    feed.quantity += feedModel.quantity ?? 0
                } else {
                    feed = Feed(context: backgroundContext)
                    feed.id = feedModel.id
                    feed.type = feedModel.type
                    feed.quantity = feedModel.quantity ?? 0
                }
                
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

    func updateFeedQuantity(id: UUID, delta: Double, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Feed> = Feed.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let feed = results.first {
                    let newQuantity = feed.quantity + delta
                    if newQuantity < 0 {
                        return
                    }
                    feed.quantity = newQuantity
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Feed not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }



    func saveMedical(medicalModel: MedicalModel, completion: @escaping (Error?) -> Void) {
        let id = medicalModel.id
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Medical> = Medical.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let medical: Medical
                
                if let existingMedical = results.first {
                    medical = existingMedical
                } else {
                    medical = Medical(context: backgroundContext)
                    medical.id = id
                }
                
                medical.procedureType = medicalModel.procedureType
                medical.visitDate = medicalModel.visitDate
                medical.animalID = medicalModel.animalID
                
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

    
//    func fetchMedicals(completion: @escaping ([MedicalModel], Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Medical> = Medical.fetchRequest()
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                var medicalsModel: [MedicalModel] = []
//                for result in results {
//                    let medicalModel = MedicalModel(id: result.id ?? UUID(), animalID: result.animalID, procedureType: result.procedureType, visitDate: result.visitDate)
//                    medicalsModel.append(medicalModel)
//                }
//                DispatchQueue.main.async {
//                    completion(medicalsModel, nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion([], error)
//                }
//            }
//        }
//    }
    
    func fetchMedicals(completion: @escaping ([MedicalModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Medical> = Medical.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var medicalsModel: [MedicalModel] = []
                for result in results {
                    var animalModel: AnimalModel? = nil
                    
                    if let animalID = result.animalID {
                        let animalFetchRequest: NSFetchRequest<Animal> = Animal.fetchRequest()
                        animalFetchRequest.predicate = NSPredicate(format: "id == %@", animalID as CVarArg)
                        if let animal = try backgroundContext.fetch(animalFetchRequest).first {
                            animalModel = AnimalModel(
                                id: animal.id ?? UUID(),
                                name: animal.name,
                                type: animal.type,
                                age: Int(animal.age)
                            )
                        }
                    }
                    
                    // Skip creating MedicalModel if animalModel is nil
                    guard let validAnimalModel = animalModel else { continue }
                    
                    let medicalModel = MedicalModel(
                        id: result.id ?? UUID(),
                        animalID: result.animalID,
                        procedureType: result.procedureType,
                        visitDate: result.visitDate,
                        animal: validAnimalModel
                    )
                    medicalsModel.append(medicalModel)
                }
                DispatchQueue.main.async {
                    completion(medicalsModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }


    
    func removeMedical(by id: UUID, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Medical> = Medical.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let medicalToDelete = results.first {
                    backgroundContext.delete(medicalToDelete)
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Medical record not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchAnimal(by id: UUID, completion: @escaping (AnimalModel?, Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Animal> = Animal.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            do {
                let result = try backgroundContext.fetch(fetchRequest).first
                if let animal = result {
                    let animalModel = AnimalModel(id: animal.id ?? UUID(), name: animal.name, type: animal.type, age: Int(animal.age))
                    DispatchQueue.main.async {
                        completion(animalModel, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Animal not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }


}

