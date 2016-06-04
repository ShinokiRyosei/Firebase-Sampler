//
//  ListViewController.swift
//  SampleFirebase
//
//  Created by ShinokiRyosei on 2016/02/27.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    var contentArray: [FIRDataSnapshot] = []
    var itemArray: [Data] = []
    let ref = FIRDatabase.database().reference()
    
    var contents = [Dictionary<String, AnyObject>]()
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var snap: FIRDataSnapshot!
    
    var selectedSnap: FIRDataSnapshot!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        table.registerNib(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        
        table.delegate = self
        table.dataSource = self
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.read()
        
        table.estimatedRowHeight = 56
        table.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        ref.removeAllObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didSelectAdd() {
        self.transition()
    }
    
    func read()  {
        //FIRDataEventTypeを.Valueにすることにより、なにかしらの変化があった時に、実行
        //Dataの個数と同じだけ、実行される
        ref.child((FIRAuth.auth()?.currentUser?.uid)!).observeEventType(.Value, withBlock: {(snapShots) in
            if snapShots.children.allObjects is [FIRDataSnapshot] {
                print("snapShots.children...\(snapShots.childrenCount)")
                
                print("snapShot...\(snapShots)")
                
                self.snap = snapShots
                
            }
            self.reload(self.snap)
        })
    }
    
    func reload(snap: FIRDataSnapshot) {
        if snap.exists() {
            contentArray.removeAll()
            for item in snap.children {
                contentArray.append(item as! FIRDataSnapshot)
            }
            table.reloadData()
        }
    }
    
    func fetch() {
        ref.child((FIRAuth.auth()?.currentUser?.uid)!).observeEventType(.Value) { (snap, str) in
            if snap.children.allObjects is [FIRDataSnapshot] {
                self.snap = snap
            }
        }
        if self.snap != nil {
            contentArray.removeAll()
            for item in snap.children {
                contentArray.append(item as! FIRDataSnapshot)
            }
            table.reloadData()
        }
    }
    
    func delete(deleteIndexPath indexPath: NSIndexPath) {
        ref.child((FIRAuth.auth()?.currentUser?.uid)!).child(contentArray[indexPath.row].key).removeValue()
        contentArray.removeAtIndex(indexPath.row)
    }
    
    func getDate(number: NSTimeInterval) -> String {
        let date = NSDate(timeIntervalSince1970: number)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.stringFromDate(date)
    }
    
    func transition() {
        self.performSegueWithIdentifier("toView", sender: self)
    }
    
    func didSelectRow(selectedIndexPath indexPath: NSIndexPath) {
        self.selectedSnap = contentArray[indexPath.row]
        self.transition()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.delete(deleteIndexPath: indexPath)
            table.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.didSelectRow(selectedIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCellWithIdentifier("ListCell") as! ListTableViewCell
        
        let item = contentArray[indexPath.row]
        let content = item.value as! Dictionary<String, AnyObject>
        cell.contentLabel.text = String(content["content"]!)
        let time = content["date"] as! NSTimeInterval
        cell.postDateLabel.text = self.getDate(time/1000)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toView" {
            let view = segue.destinationViewController as! ViewController
            if let snap = self.selectedSnap {
                view.selectedSnap = snap
            }
        }
        
    }
    
}
