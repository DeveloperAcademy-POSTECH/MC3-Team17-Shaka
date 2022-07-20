//
//  MapViewController.swift
//  shaka
//
//  Created by 최윤석 on 2022/07/20.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var waveInformationButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    //Location Manager
    let locationManager = CLLocationManager()
    //Current Location of User
    var currentLocation: CLLocationCoordinate2D?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        locationConfiguration()
        // Do any additional setup after loading the view.
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(testForLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 1
        mapView.addGestureRecognizer(longPressGesture)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //뷰 생성 후 처음 실행되는 부분
    private func locationConfiguration(){
        locationManager.delegate = self
        //위치 권한 확인
        let status = locationManager.authorizationStatus
        //권한이 설정되어 있지 않다면, 설정
        if status == .notDetermined{
            locationManager.requestAlwaysAuthorization()
        }else if status == .authorizedAlways || status == .authorizedWhenInUse{
            beginToTrackUserLocation(with: locationManager)
        }
    }
    
    //사용자의 현재 위치를 받아서 추적하는 메소드
    private func beginToTrackUserLocation(with manager: CLLocationManager){
        mapView.showsUserLocation = true
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    //나침판 버튼 누르면, 사용자의 위치로 줌인 되는 메소드
    private func zoomToCurrentUserLocation(with coordinates: CLLocationCoordinate2D){
        let mapRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mapRegion, animated: true)
    }
    
    //좌표 찾기 위한 테스트 함수
    @objc func testForLongPress(gesture: UILongPressGestureRecognizer){
        print("test for longpress")
    }
    
    //나침판 버튼 클릭시에 대한 이벤트 실행
    @IBAction func findCurrentLocation(_ sender: Any) {
        let status = locationManager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways{
            zoomToCurrentUserLocation(with: currentLocation!)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print("User location Updated")
        guard let location = locations.first else{ return }
        if currentLocation == nil{
            zoomToCurrentUserLocation(with: location.coordinate)
        }
        currentLocation = location.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager){
        print("Auth Changed to",manager.authorizationStatus.rawValue)
        let status = manager.authorizationStatus
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            beginToTrackUserLocation(with: manager)
        }
    }
}

//setting code for UIView, UIButton shadow property
@IBDesignable extension UIView {
    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    @IBInspectable var shadowOpacity: CGFloat {
        get { return CGFloat(layer.shadowOpacity) }
        set { layer.shadowOpacity = Float(newValue) }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let cgColor = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
}
