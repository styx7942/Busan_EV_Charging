//
//  ListTableViewController.swift
//  getmap
//
//  Created by 이현호 on 2017. 11. 23..
//  Copyright © 2017년 이현호. All rights reserved.
//
//resultCode : 결과코드
//resultMsg : 결과메세지
//numOfRows : 한 페이지 결과 수
//pageNo : 페이지 번호
//totalCount : 전체 결과 수

//items : 목록
//addr : 충전소주소
//chargeTp : 충전기타입
//cpId : 충전소ID
//cpNm : 충전기명칭
//cpStat : 충전기 상태 코드
//cpTp : 충전방식
//csId : 충전소ID
//csNm : 충전소 명칭
//lat : 위도
//longi : 경도
//statUpdateDatetime : 충전기 상태 갱신 시각


//cpTp : 충전방식
//1 : B타입(5핀)
//2 : C타입(5핀)
//3 : BC타입(5핀)
//4 : BC타입(7핀)
//5 : DC차데모
//6 : AC3상
//7 : DC콤보
//8 : DC차데모+DC콤보
//9 : DC차데모+AC3상
//10 : DC차데모+DC콤보+AC3상


import UIKit

class ListTableViewController: UITableViewController {
    @IBOutlet var myTableView: UITableView!
    
    @IBAction func segmentItem(_ sender: UISegmentedControl) {
    }
    
    var currentlat : Double = 0
    var currentlong : Double = 0
    
    
    var current = ""
    
    let color1 = UIColor(red: 0.3,green: 0.3,blue: 0.3,alpha: 2)
    let color11 = UIColor(red: 0.7,green: 0.7,blue: 0.7,alpha: 2)
    let color2 = UIColor(red: 0,green: 1,blue: 0,alpha: 0.8)
    let color3 = UIColor(red: 0,green: 0.6,blue: 1,alpha: 0.5)
    let color4 = UIColor(red: 0,green: 0,blue: 0,alpha: 1)
    
    
    
    
    
    
    
    
    var listItems:[[String:String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.estimatedRowHeight = 150
        
        print(listItems)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "listcell", for: indexPath) as! MyTableViewCell
        
        cell.csNmlbl.textColor = color1
        cell.addrlbl.textColor = color3
        cell.cpTplbl.textColor = color11

        
        let dic = listItems[indexPath.row]
        
        if dic["cpTp"] == "10"{
            cell.cpTplbl.text = "DC차데모+DC콤보+AC3상"
        }else if dic["cpTp"] == "9"{
            cell.cpTplbl.text = "DC차데모+AC3상"
        }else if dic["cpTp"] == "8"{
            cell.cpTplbl.text = "DC차데모+DC콤보"
        }else if dic["cpTp"] == "7"{
            cell.cpTplbl.text = "DC콤보"
        }else if dic["cpTp"] == "6"{
            cell.cpTplbl.text = "AC3상"
        }else{
            cell.cpTplbl.text = dic["cpTp"]
        }
        
        
        let num : Int = Int(dic["cpStat"]!)!
        switch num {
        case 1...15:
            cell.cpStatlbl.text = "충전중"
            cell.cpStatlbl.textColor = color2
        case 16...32:
            cell.cpStatlbl.text = "사용불가"
            cell.cpStatlbl.textColor = color1
        case 0,  40:
            cell.cpStatlbl.text = "통신미연결"
            cell.cpStatlbl.textColor = color4
        default:
            break
        }
        
        print("lat : \((Double(dic["lat"]!)! - currentlat)*111000)")
        print("long : \((Double(dic["longi"]!)! - currentlong)*88800)")
        
//        sqrt(((Double(dic["lat"]!)! - currentlat)*(Double(dic["lat"]!)! - currentlat))+((Double(dic["longi"]!)! - currentlong)*(Double(dic["longi"]!)! - currentlong)))
        cell.csNmlbl.text = dic["csNm"]
        let numberOfPlaces = 1.0
        current = String(sqrt((((Double(dic["lat"]!)! - currentlat)*(Double(dic["lat"]!)! - currentlat))*111000+((Double(dic["longi"]!)! - currentlong)*(Double(dic["longi"]!)! - currentlong))*88800)))
        let multiplier = pow(10.0, numberOfPlaces)
        current = String(round(Double(current)! * multiplier)/multiplier)
        cell.addrlbl.text = "\(Int(Double(current)!)/3)km"
//        cell.addrlbl.text = dic["addr"]
//        cell.cpStatlbl.text = dic["cpStat"]
        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
