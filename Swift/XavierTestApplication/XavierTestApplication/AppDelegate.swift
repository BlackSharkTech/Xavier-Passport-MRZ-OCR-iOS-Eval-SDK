//
//  AppDelegate.swift
//  Paging_Swift
//
//  Copyright (c) 2015 SimonComputing. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Variables
    var window: UIWindow?
    open var viewController:XavierViewController?
    var managedObjectContext:NSManagedObjectContext?
    var managedObjectModel:NSManagedObjectModel?
    var persistentStoreCoordinator:NSPersistentStoreCoordinator?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
    }
    
    func manageObjectModel() -> NSManagedObjectModel? {
        if( self.managedObjectModel != nil) {
            return self.managedObjectModel!
        }
        let modelURL:URL = Bundle.main.url(forResource: "XavierTestApp", withExtension: "momd")!
        managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        return managedObjectModel!
    }
    
    func persistStoreCoordinator() -> NSPersistentStoreCoordinator? {
        if(self.persistentStoreCoordinator != nil) {
            return self.persistentStoreCoordinator!
        }
        
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.manageObjectModel()!)
        let storeUrl = self.applicationDocumentsDirectory().appendingPathComponent("XavierTestApp.sqlite")
        let errors:NSError? = nil
        let failureReason:String? = "There was an error creating or loading the application's saved data."
        do {
            try persistentStoreCoordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: nil)
        } catch _ {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason! as AnyObject?
            dict[NSUnderlyingErrorKey] = errors!
            let errors = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            print("Unresolved errors: \(errors), \(errors.userInfo)")
            abort()
        }
        return persistentStoreCoordinator!
    }
    
    func manageObjectContext() -> NSManagedObjectContext? {
        if(managedObjectContext != nil) {
            return managedObjectContext!
        }
        
        let coordinator:NSPersistentStoreCoordinator? = self.persistStoreCoordinator()
        if(coordinator == nil) {
            return nil
        }
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext?.persistentStoreCoordinator = coordinator
        return managedObjectContext!
    }
    
    func saveContext() -> Void {
        let managedObjContext:NSManagedObjectContext = self.managedObjectContext!
        if(self.managedObjectContext != nil) {
            let errors:NSError? = nil
            if(managedObjContext.hasChanges) {
                do {
                    try managedObjContext.save()
                } catch _ {
                    print("Unresolved errors: \(errors), \(errors!.userInfo)")
                    abort()
                }
            }
        }
    }
    
}

