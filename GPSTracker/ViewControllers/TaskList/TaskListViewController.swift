//
//  TaskListViewController.swift
//  GPSTracker
//
//  Created by sensussoft on 1/30/18.
//  Copyright © 2018 Sensu Soft. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController {

    //MARK: - IBoutlet 
    @IBOutlet var tblTaskList: UITableView!
    var arrTasks = [TaskListModel]()
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        self.callAPITaskList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        self.title = "Tasks List"
    }
    
    //MARK: Custom methods
    func setUI() {
        tblTaskList.register(UINib(nibName: "TaskListCell", bundle: nil), forCellReuseIdentifier: "TaskListCell")
    }
    
    //MARK: Call API
    func callAPITaskList() {
        var param = [String: AnyObject]()
        param["user_name"] = AIUser.sharedManager.user_login as AnyObject?
        
        ServiceManager.apiTaskList(param) { (isSuccess, arr) in
            if (isSuccess){
                for item in arr{
                    let model = TaskListModel()
                    model.setData(dict: item as NSDictionary)
                    self.arrTasks.append(model)
                }
                self.tblTaskList.reloadData()
            }
        }
    }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell") as! TaskListCell
        let model = arrTasks[indexPath.row]
        cell.lblTaskId.text = model.TaskId
        cell.lblTaskType.text = model.TaskType
        cell.lblTaskNote.text = model.TaskNotes
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 95;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = arrTasks[indexPath.row]
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "GPSTrackerViewController") as! GPSTrackerViewController
        VC.taskModel = model
        self.navigationController?.pushViewController(VC, animated: true)
    }
}
