//
//  ChildrenViewController.swift
//  Wehere
//
//  Created by Zakhar Rudenko on 23.05.16.
//  Copyright © 2016 Zakhar Rudenko. All rights reserved.
//

import UIKit
import CoreData

//
//class ChildrenViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
//    var usersArray = [UserDataClass]()
//    
//    @IBOutlet weak var collectionView: UICollectionView!
// var TableData:Array< UserDataClass > = Array < UserDataClass >()
//    
//    enum ErrorHandler:ErrorType{
//        case ErrorFetchingResults
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        read()
//    }
//
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
//    {
//        let cell = collectionView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellChildrenTableView
//        
//        
//        let data = TableData[indexPath.row]
//        
////            let decodedData = NSData(base64EncodedString: data.link_to_image!, options: NSDataBase64DecodingOptions(rawValue: 0))
////            let decodedImage = UIImage(data: decodedData!)
//        
//    //    cell.thumbnailImageView?.image = data.link_to_image
//    //    cell.nameChildren.text = data.name
//        return cell
//    }
//    
//    func do_table_refresh()
//    {
//        dispatch_async(dispatch_get_main_queue(), {
//            self.collectionView.reloadData()
//            return
//        })
//    }
//
//
//    func read() {
//                do
//        {
//            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            let managedContext = appDelegate.managedObjectContext
//            let fetchRequest = NSFetchRequest(entityName: "User")
//            
//            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest)
//            print(fetchedResults.count)
//            for (var i=0; i < fetchedResults.count; i += 1)
//            {
//                let single_result = fetchedResults[i]
//                
//                let latitude = single_result.valueForKey("latitude") as! Double
//                let longitude = single_result.valueForKey("longitude") as! Double
//                let deviceId = single_result.valueForKey("deviceId") as! String
//                let link_to_image = single_result.valueForKey("link_to_image") as! String
//                let name = single_result.valueForKey("name") as! String
//                let user = single_result.valueForKey("user") as! String
//                let howAreYou = UserDataClass(latitude: latitude, longitude: longitude, deviceId: deviceId, link_to_image: link_to_image, name: name, user: user)
//                usersArray.append(howAreYou)
//            
//                TableData.append(howAreYou)
//            }
//        }
//        catch
//        {
//            print("error")
//        }
//         do_table_refresh()
//        
//    }
//    
////    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        
////        return self.TableData.count
////    }
////    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
////        return 1
////    }
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//}