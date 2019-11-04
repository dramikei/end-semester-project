//
//  TimeTableVC.swift
//  atendance-system-client
//
//  Created by Raghav Vashisht on 05/10/19.
//  Copyright © 2019 Raghav Vashisht. All rights reserved.
//

import UIKit
import Alamofire

class TimeTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "TTCell"
    var timetables: [TimeTable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let parameterdata = [
            "enrolment": userEnrolment
        ]
        AF.request(getTimeTableURL, method: .post, parameters: parameterdata, encoder: JSONParameterEncoder.default, headers: nil, interceptor: nil).responseJSON { response in
            guard let data = response.data else { return }
            
            do {
                let decoder = JSONDecoder()
                let timetables = try decoder.decode(TimeTableList.self, from: data)
                self.timetables = timetables.timetables
                self.tableView.reloadData()
            } catch let error {
                print(error)
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timetables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? TTCell else { return UITableViewCell() }
        if timetables.count > 0 {
            cell.teacherLabel.text = timetables[indexPath.row].teacherName
            cell.subjectLabel.text = timetables[indexPath.row].subject.uppercased()
            cell.timeLabel.text = timetables[indexPath.row].time
            cell.classLabel.text = timetables[indexPath.row].hallName.uppercased()
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

}
