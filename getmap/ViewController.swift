//
//  ViewController.swift
//  getmap
//
//  Created by 이현호 on 2017. 11. 22..
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
import MapKit
import CoreLocation

class ViewController: UIViewController,MKMapViewDelegate,XMLParserDelegate,CLLocationManagerDelegate {

    
    @IBOutlet weak var segmentItem: UISegmentedControl!
    @IBOutlet weak var myMapView: MKMapView!
    @IBAction func segmentBtn(_ sender: UISegmentedControl) {
        zoomToRegion()
        print(locationManager.location?.coordinate.latitude)
        switch segmentItem.selectedSegmentIndex {
        case 0:
            myMapView.showAnnotations(annos, animated: true)
        default:
            break
        }
    }
    
    //현
    
    
    
    var serviceMsg = "" //서비스상태
    var item:[String:String] = [:]
    var items:[[String:String]] = []
    
    var key = ""
    //    var servieKey = "tEp33kHhaR2SwQPmwWE1r6qwrhUTu1il2PVNGZEGwyvkm8i3MSl6dtzet1Mxofc7tCG1wZTkGjk0W47GM6bxSA%3D%3D"
    
    //규식
    //    var servieKey = "nsGYsnRIMYDW2RwmA8hMBTGFXYN6LyB4rJC71IIGNVGIplpzE3iahHPLqCU4BnTjhOGT4b%2FgbTLg3vfGFtIffQ%3D%3D"
    
    //민우
    var servieKey = "XRcD2BtScfry3R19eGO%2FNR7cx9DTbKu4EOQjZiaDgTC48fA6Y1R7unCSNHsnKVzpSjVPfYtXFuzwEPclYn0Rew%3D%3D"
    
    var listEndPoint = "http://openapi.kepco.co.kr/service/evInfoService/getEvSearchList"
    
    var totalCount = 0 //총 갯수를 저장하는 변수
    
    
    
    
    
    //트래킹
    var locationManager: CLLocationManager!
    var annos = [MKPointAnnotation]()
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "부산 전기차 충전소"
        
        
        
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("data.plist")
        //시작할때마다 TotalCount를 받아옴
        getList(numOfRows: 0)
        
        if fileManager.fileExists(atPath: (url?.path)!) {
            //파일이 있으면 파일에서 읽어옴
            items = NSArray(contentsOf: url!) as! Array
            print("파일 있음")
            
        }else{
            print("파일 없음")
            getList(numOfRows: totalCount)
            
        }
        
        mapa()
        
        
        
        //-------------------------------------------------
//        zoomToRegion()
        
//        let path = Bundle.main.path(forResource: "ViewPoint2", ofType: "plist")
//        print("path = \(String(describing: path))")
//
//        let contents = NSArray(contentsOfFile: path!)
//        print("path = \(String(describing: contents))")
//
//        var annotations = [MKPointAnnotation]()
//
//        // optional binding
//        if let myItems = contents {
//            // Dictionary Array에서 값 뽑기
//            for item in myItems {
//                let lat = (item as AnyObject).value(forKey: "lat")
//                let long = (item as AnyObject).value(forKey: "long")
//                let title = (item as AnyObject).value(forKey: "title")
//                let subTitle = (item as AnyObject).value(forKey: "subTitle")
//                //let img = (item as AnyObject).value(forKey: "img")
//
//                let annotation = MKPointAnnotation()
//
//                print("lat = \(String(describing: lat))")
//
//                let myLat = (lat as! NSString).doubleValue
//                let myLong = (long as! NSString).doubleValue
//                let myTitle = title as! String
//                let mySubTitle = subTitle as! String
//
//                print("myLat = \(myLat)")
//
//                annotation.coordinate.latitude = myLat
//                annotation.coordinate.longitude = myLong
//                annotation.title = myTitle
//                annotation.subtitle = mySubTitle
//
//                annotations.append(annotation)
//
//                myMapView.delegate = self
//
//            }
//        } else {
//            print("contents의 값은 nil")
//        }
//
//        // 전체 핀이 지도에 보이도록 함
//        myMapView.showAnnotations(annotations, animated: true)
//
//        //핀 하나가 자동으로 탭되도록 처리
//        myMapView.selectAnnotation(annotations[0], animated: true)
//
//        myMapView.addAnnotations(annotations)
//        //----------------------------------------------------
        
        
        
        
        
        
        
        
        
        
        
        
        //트래킹
        // 현재 위치 트랙킹
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
//        locationManager.startUpdatingHeading()
        
        
        
        // 지도에 현재 위치 마크를 보여줌
        myMapView.showsUserLocation = true
    }

    


    
    
    
    
    
    
    func zoomToRegion() {
        // 35.162685, 129.064238
        let center = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!)
        var span = MKCoordinateSpanMake(0.35, 0.44)
        switch segmentItem.selectedSegmentIndex {
        case 1:
            span = MKCoordinateSpanMake(0.05, 0.04)
            
        case 2:
            span = MKCoordinateSpanMake(0.125, 0.1)
        case 3:
            span = MKCoordinateSpanMake(0.25, 0.2)
        default:
            span = MKCoordinateSpanMake(0.35, 0.44)
        }
        
        print(segmentItem.selectedSegmentIndex)
        let region = MKCoordinateRegionMake(center, span)
        myMapView.setRegion(region, animated: true)
    }
    
    
    
    
    
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        print("callout Accessory Tapped!")
        
        let viewAnno = view.annotation
        let viewTitle: String = ((viewAnno?.title)!)!
        let viewSubTitle: String = ((viewAnno?.subtitle)!)!
        
        print("\(viewTitle) \(viewSubTitle)")
        
        let ac = UIAlertController(title: viewTitle, message: viewSubTitle, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    
    
    
    func getList(numOfRows:Int){
        let str = listEndPoint + "?serviceKey=\(servieKey)&numOfRows=\(numOfRows)&addr=%EB%B6%80%EC%82%B0"
        
        print(str)
        if let url = URL(string: str) {
            if let parser = XMLParser(contentsOf: url) {
                parser.delegate = self
                let success = parser.parse()
                if success {
                    print("파싱성공")
                    print("totalCount = \(totalCount)")
                    if totalCount != 0{
//                        mapa()
                    }
                    
                } else {
                    print("파싱실패")
                }
            }
        }
    }
    
    
    
    
    
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        key = elementName
        print("key = \(key)")
        if key == "item" {
            item = [:]  //item태그 확인후 공간생성
        }
        if elementName == "resultMsg"{
            serviceMsg = "resultMsg"
        }
    }
    //---------------------------------
    
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //api상태
        if serviceMsg == "resultMsg"{
            print("현재 서비스상태 : \(string.trimmingCharacters(in: .whitespaces))")
            serviceMsg = ""
        }
        
        
        // foundCharacters가 두번 호출
        if item[key] == nil {
            item[key] = string.trimmingCharacters(in: .whitespaces)
            //print("item(\(key)) = \(item[key])")
            
            //*******key가 totalCount 이면 totalCount 변수에 저장
            if key == "totalCount" {
                totalCount = Int(string.trimmingCharacters(in: .whitespaces))!
            }
        }
        
    }
    //---------------------------------
    
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            items.append(item)
            print(items)
            
        }
        
    }
    //---------------------------------
    
    
    func mapa(){
        
        
        
        for item in items {
            let anno = MKPointAnnotation()
            
            let lat = item["lat"]
            let long = item["longi"]
            
            let fLat = (lat! as NSString).doubleValue
            let fLong = (long! as NSString).doubleValue
            
            anno.coordinate.latitude = fLat
            anno.coordinate.longitude = fLong
            anno.title = item["csNm"]
            anno.subtitle = item["cpTp"]
            
            
//            let num : Int = Int(item["cpStat"]!)!
//            switch num {
//            case 1...15:
////                cell.cpStatlbl.text = "충전중"
//                annos
//                cell.cpStatlbl.textColor = UIColor.green
//            case 16...32:
////                cell.cpStatlbl.text = "사용불가"
//                cell.cpStatlbl.textColor = UIColor.red
//            case 0,  40:
////                cell.cpStatlbl.text = "통신미연결"
//                cell.cpStatlbl.textColor = UIColor.black
//            default:
//                break
//            }
            
            
            annos.append(anno)
            
        }
        
        
        
        
        
        
        myMapView.delegate = self
        
        
        
        
        
        
        // 전체 핀이 지도에 보이도록 함
        myMapView.showAnnotations(annos, animated: true)
        
        
        //핀 하나가 자동으로 탭되도록 처리
        myMapView.selectAnnotation(annos[1], animated: true)
        
        myMapView.addAnnotations(annos)
    }
    
    
    
    
    
    
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        var  annotationView = myMapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        
        
            
            print("아노테이션 : \(annotation.subtitle)")
            
        
            
            
            if annotation.subtitle! == "10"{
                annotationView?.pinTintColor = UIColor.magenta
               
            }else if annotation.subtitle! == "9"{
                annotationView?.pinTintColor = UIColor.orange
                
            }else if annotation.subtitle! == "8"{
                annotationView?.pinTintColor = UIColor.orange
            }else if annotation.subtitle! == "7"{
                annotationView?.pinTintColor = UIColor.cyan
            }else if annotation.subtitle! == "6"{
                annotationView?.pinTintColor = UIColor.gray
            }else if annotation.subtitle! == "5"{
                annotationView?.pinTintColor = UIColor.brown
            }else if annotation.subtitle! == "4"{
                
            }else if annotation.subtitle! == "3"{
                
            }else if annotation.subtitle! == "2"{
                
            }else if annotation.subtitle! == "1"{
                
            }else{
                print(annotation.subtitle)
            }
        }
        return annotationView
    }
    
    
    
    
    
    
    
    
    
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        region.center = myMapView.userLocation.coordinate
        myMapView.setRegion(region, animated: true)
        print("\(location.coordinate.latitude), \(location.coordinate.longitude)")
    }
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "goList" {
            let totalMVC = segue.destination as! ListTableViewController
            totalMVC.listItems = items
            totalMVC.currentlat =  Double((locationManager.location?.coordinate.latitude)!)
            totalMVC.currentlong =  Double((locationManager.location?.coordinate.longitude)!)
        }
//        else if segue.identifier == "goSingleMap" {
//            let singleMTVC = segue.destination as! SingleMapTableViewController
//            let selectedIndex = tableView.indexPathForSelectedRow
//            singleMTVC.sItem = items[(selectedIndex?.row)!]
//
//        }
    }
}
