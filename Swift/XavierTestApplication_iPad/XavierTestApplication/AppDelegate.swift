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
    public var viewController:XavierViewController?
    var managedObjectContext:NSManagedObjectContext?
    var managedObjectModel:NSManagedObjectModel?
    var persistentStoreCoordinator:NSPersistentStoreCoordinator?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationDocumentsDirectory() -> NSURL {
        return FileManager.default.URLsForDirectory(FileManager.SearchPathDirectory.DocumentDirectory, inDomains: FileManager.SearchPathDomainMask.UserDomainMask).last!
    }
    
    func manageObjectModel() -> NSManagedObjectModel? {
        if( self.managedObjectModel != nil) {
            return self.managedObjectModel!
        }
        let modelURL:NSURL = Bundle.main.url(forResource: "XavierTestApp", withExtension: "momd")! as NSURL
        managedObjectModel = NSManagedObjectModel(contentsOf: modelURL as URL)
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
            let dict:NSMutableDictionary = [NSLocalizedDescriptionKey:"Failed to initialize the application's saved data", NSLocalizedFailureReasonErrorKey:failureReason!, NSUnderlyingErrorKey:errors!]
            let errors = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
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
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyTypemainQueueConcurrencyType)
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

