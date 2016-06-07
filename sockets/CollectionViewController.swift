//
//  CollectionViewController.swift
//  Wehere
//
//  Created by Zakhar Rudenko on 05.06.16.
//  Copyright © 2016 Zakhar Rudenko. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AlamofireImage


class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var profileFamily: UILabel!
    @IBOutlet var collectionView: UICollectionView!

    
    
        let URL_IMAGE = "http://176.56.50.175:8080/image_user/"
        var TableData:Array< UserDataClass > = Array < UserDataClass >()
        var usersArray = [UserDataClass]()
        
        enum ErrorHandler:ErrorType{
                    case ErrorFetchingResults
                }

        func do_table_refresh(){
        
            dispatch_async(dispatch_get_main_queue(), {
                self.collectionView.reloadData()
                return
            })
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            read()
            initData()

        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        
        //UICollectionViewDatasource methods
        func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
            
            return 1
        }
        
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            

            return usersArray.count
        }
        
        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            
            let data1 = TableData[indexPath.row]

            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellIdentifer", forIndexPath: indexPath) as! CellChildrenTableView
            Alamofire.request(.GET,URL_IMAGE+usersArray[indexPath.row].link_to_image!).responseImage { response in
                   
                    cell.imageView.image = UIImage(data: response.data!, scale: 1)
                    
                    if let image = response.result.value {
                        print("image downloaded: \(image)")
                    }}
            
                    cell.nameChildren.text = usersArray[indexPath.row].name
            return cell
    }
            
        func randomColor() -> UIColor{
            let red = CGFloat(drand48())
            let green = CGFloat(drand48())
            let blue = CGFloat(drand48())
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    
        func read() {
                do
                    {
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        let managedContext = appDelegate.managedObjectContext
                        let fetchRequest = NSFetchRequest(entityName: "User")

                        let fetchedResults = try managedContext.executeFetchRequest(fetchRequest)

                        for (var i=0; i < fetchedResults.count; i += 1)
                        {
                            let single_result = fetchedResults[i]
            
                            let latitude = single_result.valueForKey("latitude") as! Double
                            let longitude = single_result.valueForKey("longitude") as! Double
                            let deviceId = single_result.valueForKey("deviceId") as! String
                            let link_to_image = single_result.valueForKey("link_to_image") as! String
                            let name = single_result.valueForKey("name") as! String
                            let user = single_result.valueForKey("user") as! String
                            let root = single_result.valueForKey("root") as! String
                            let howAreYou = UserDataClass(latitude: latitude, longitude: longitude, deviceId: deviceId, link_to_image: link_to_image, name: name, user: user,root: root)
                            usersArray.append(howAreYou)
                        
                            TableData.append(howAreYou)
                        }
                    }
                    catch
                    {
                        print("error")
                    }
                     do_table_refresh()
                    
                }
    
    
    
    func initData() {
        do
        {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let fetchRequest = NSFetchRequest(entityName: "User")
            let root = "1"
            fetchRequest.predicate = NSPredicate(format: "root == %@", root)
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest)
            
            for (var i=0; i < fetchedResults.count; i += 1)
            {
                let single_result = fetchedResults[i]
                
                let latitude = single_result.valueForKey("latitude") as! Double
                let longitude = single_result.valueForKey("longitude") as! Double
                let deviceId = single_result.valueForKey("deviceId") as! String
                let link_to_image = single_result.valueForKey("link_to_image") as! String
                let name = single_result.valueForKey("name") as! String
                let user = single_result.valueForKey("user") as! String
                let root = single_result.valueForKey("root") as! String
                
                profileName.text = name
                profileFamily.text = String(usersArray.count) + " членов в голове"
                Alamofire.request(.GET,URL_IMAGE+link_to_image).responseImage { response in
                    self.profileImage.image = UIImage(data: response.data!, scale: 1)

                }
                
                    // @IBOutlet var profileImage: UIImageView!
               // @IBOutlet var profileName: UILabel!
               // @IBOutlet var profileFamily: UILabel!
            }
        }
        catch
        {
            print("error")
        }
        
    }
//        UICollectionViewDelegateFlowLayout methods
//                func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
//
//                    return 3;
//                }
//                func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
//        
//                    return 1;
//                }
//        

}