//
//  ViewController.swift
//  LBSAnJT
//
//  Created by liangqiao on 2021/11/16.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    var currentLocation :CLLocationCoordinate2D?
    var lock = NSLock()
    let trans = Trans()
    var locations = [CLLocationCoordinate2D]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 前后台监听
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1
        // 弹出用户授权对话框，使用程序期间授权
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        
        didChangeAuthorization()
        
        print("start")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func enterBackground(notification: NSNotification){
        print("back")
        locationManager.distanceFilter = 2
    }
    
    @objc func enterForeground(notification: NSNotification){
        print("fore")
        if locationManager.distanceFilter == 2 && (locations.count >= 2){
            let ployline = MKPolyline(coordinates: locations, count: locations.count)
            mapView.addOverlay(ployline)
            let location = locations[locations.endIndex - 1]
            locations.removeAll()
            locations.append(location)
        }
        locationManager.distanceFilter = 1
    }
    
    func foreOverlay(_ location: CLLocationCoordinate2D){
        locations.append(location)
        let ployline = MKPolyline(coordinates: locations, count: locations.count)
        mapView.addOverlay(ployline)
        locations.remove(at: 0)
    }
    
    func backOverlay(_ location: CLLocationCoordinate2D){
        locations.append(location)
        if locations.count > 20 {
            let ployline = MKPolyline(coordinates: locations, count: locations.count)
            mapView.addOverlay(ployline)
            locations.removeAll()
            locations.append(location)
        }
    }
    
    //弹窗提醒
    func help(){
        let alert = UIAlertController(title: "系统提示", message: "没有定位权限", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func didChangeAuthorization(){
        switch locationManager.authorizationStatus {
        case .restricted, .denied:
            self.locationManager.stopUpdatingLocation()
            help()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.stopUpdatingLocation()
        default:
            break
        }
        if locationManager.authorizationStatus == .restricted || locationManager.authorizationStatus == .denied{
            help()
        }
    }
    
    //改变权限
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(locationManager.accuracyAuthorization)
        print("hh")
        didChangeAuthorization()
    }
    
    //委托传回定位，获取最后一个
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lock.lock()
        print(self.locations.count)
        // 获取集合中最后一个位置（最新的位置）
        guard let newLocation = locations.last else {return}
        let location = trans.transformFromWGSToGCJ(wgsLoc: newLocation.coordinate)
        if self.locations.count == 0{
            self.locations.append(location)
        }
        else{
            if locationManager.distanceFilter == 1{
                foreOverlay(location)
            }
            else{
                backOverlay(location)
            }
        }
        lock.unlock()
    }
    
    // renderer
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.fillColor = UIColor.blue
        polylineRenderer.strokeColor = UIColor.green
        polylineRenderer.lineWidth = 5
        return polylineRenderer
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("定位出错拉！！\(error)")
    }
}
