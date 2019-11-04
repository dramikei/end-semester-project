//
//  AttendanceVC.swift
//  atendance-system-client
//
//  Created by Raghav Vashisht on 05/10/19.
//  Copyright © 2019 Raghav Vashisht. All rights reserved.
//

import UIKit
import Alamofire

class AttendanceVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let identifier = "attendanceIdentifier"
    var attendances: [TimeTable] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
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
                let attendances = try decoder.decode(TimeTableList.self, from: data)
                self.attendances = attendances.timetables
                self.tableView.reloadData()
            } catch let error {
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.attendances.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AttendanceCell else { return UITableViewCell() }
        if self.attendances.count > 0 {
            cell.subjectName.text = self.attendances[indexPath.row].subject.uppercased()
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AttendanceCell
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "SubjectVC") as! SubjectVC
        vc.subjectName = cell.subjectName.text!
        present(vc, animated: true, completion: nil)
    }
    

}
