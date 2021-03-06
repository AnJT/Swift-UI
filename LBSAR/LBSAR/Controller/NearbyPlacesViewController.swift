//
//  NearbyPlacesViewController.swift
//  LBSAR
//
//  Created by ajt on 2021/12/16.
//

import UIKit
import GoogleMaps
import MapKit
import HDAugmentedReality

class NearbyPlacesViewController: UIViewController {
    @IBOutlet weak var googleMaps: GMSMapView!
    @IBOutlet weak var btnArview: UIButton!

    var aHomeItem = HomeItem()
    var aPlace: Place?

    let locationManager = CLLocationManager()
    var tappedMarker : GMSMarker?
    var customInfoWindow : MarkerCustomInfo?
    var arViewController: ARViewController!
    var places = [Place]()
    var loadPOIsOnlyOnce = false
    var currentLocation: CLLocation?
    let trans = Trans()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nearby \(aHomeItem.itemTitle)"
        
        configureMap()
    }
    
    func configureMap() {
        locationManager.delegate = self
        // locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 省点电
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
        // 设置googleMap画布的默认位置
        let camera = GMSCameraPosition.camera(withLatitude: 31.281571640459426, longitude: 121.21394959910727, zoom: 15.0)
        googleMaps.camera = camera
        
        googleMaps.delegate = self
        // 显示当前位置
        googleMaps?.isMyLocationEnabled = true
        // 显示自己的位置、指南针标识
        googleMaps.settings.myLocationButton = true
        googleMaps.settings.compassButton = true
        // 启用缩放手势
        googleMaps.settings.zoomGestures = true
        
        customInfoWindow = MarkerCustomInfo().loadView()
        customInfoWindow?.delegate = self
    }

    // MARK: - Navigation

    // 跳转至Director时传值调用
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let directionVC = segue.destination as? DirectionViewController {
            self.aPlace?.curLocation = self.currentLocation
            directionVC.aHomeItem = self.aHomeItem
            directionVC.aPlace = self.aPlace
        }
    }

    // MARK: - Private Methods
    
    // 调整map画布的位置
    private func setupCameraPosition() {
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude, zoom: 15.0)
        googleMaps.animate(to: camera)
        let curPlaceMark = GMSMarker()
        curPlaceMark.position = CLLocationCoordinate2DMake(currentLocation!.coordinate.latitude, currentLocation!.coordinate.longitude)
        curPlaceMark.map = self.googleMaps
    }
    
    // 根据当前位置以及key获取周边信息
    private func loadNearbyPlacesData() {
        WebServices.loadNearbyPointOfInterest(location: currentLocation!, radius: Constants.Preferences.mapRadius, searchKey: aHomeItem.key) { (results) in
            DispatchQueue.main.async {
                guard let pointofInterest = results else {return}
                self.plotMarkersOnMapWith(pointofInterest)
            }
        }
    }
    
    // 打标记
    private func plotMarkersOnMapWith(_ placeDataArr: [Results]) {
        self.places = DataAssemble.prepareData(placeDataArr)
        for place in places {
            let marker = MyMarker()
            let image = UIImage(named: aHomeItem.key)
            
            marker.position = CLLocationCoordinate2DMake(place.latitude!, place.longitude!)
            marker.place = place
            marker.icon = image
            marker.map = self.googleMaps
        }
    }
    
    // 点到marker的时候显示当前marker的一些信息
    private func displayPlaceInformationAt(_ position:CLLocationCoordinate2D, aPlace: Place, for mapView: GMSMapView) {
        self.aPlace = aPlace
        // 将GMSMapView上的位置转换为屏幕的坐标系
        customInfoWindow?.center = mapView.projection.point(for: position)
        // Convent CGPoint to Lat Long (消除偏移)
        customInfoWindow?.center.y -= 100
        customInfoWindow?.lblClose.text = aPlace.openNow ? "Open" : "Close"
        customInfoWindow?.lblTitle.text = aPlace.placeName
        customInfoWindow?.lblTotalUserRating.text = "Total User Rating: \(aPlace.userTotalRating)"
                        
        customInfoWindow?.imagePlace.setImageWith(url: URL.init(string: aPlace.imageUrl)!, placeholderImage: UIImage(named: "Placeholder")!)
        customInfoWindow?.ratingView.rating = aPlace.rating
        
        googleMaps.addSubview(customInfoWindow!)
    }
    
    // MARK: - IBAction Methods

    @IBAction func showARController(_ sender: Any) {
        arViewController = ARViewController()
        // 设置 arViewController 的数据源。数据源负责提供需要显示的 POI
        arViewController.dataSource = self
        arViewController.trackingManager.userDistanceFilter = 25
        arViewController.trackingManager.reloadDistanceFilter = 75

        if let presenter = arViewController.presenter {
            presenter.presenterTransform = ARPresenterStackTransform()
            presenter.maxDistance = 0
            presenter.maxVisibleAnnotations = 30
        }
        
        let trackingManager = arViewController.trackingManager
        trackingManager.userDistanceFilter = 15
        trackingManager.reloadDistanceFilter = 50
        trackingManager.filterFactor = 0.4
        trackingManager.minimumTimeBetweenLocationUpdates = 2
        
        arViewController.setAnnotations(places)
        
        arViewController.modalPresentationStyle = .fullScreen
        present(arViewController, animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate Methods

extension NearbyPlacesViewController: CLLocationManagerDelegate {
    // 当在室内、地下、有磁场干扰或者很久没有用指南针时系统发现方向不够准确时自动弹出校准。
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    // 获取当前位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locations.isEmpty else {return}
        // get current location
        let location = trans.transformFromWGSToGCJ(wgsLoc: locations.last!.coordinate)
        currentLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        // currentLocation = locations.last!
        // 定位精度
        if currentLocation!.horizontalAccuracy < 100 {
            manager.stopUpdatingLocation()
            
            if !loadPOIsOnlyOnce {
                setupCameraPosition()
                loadNearbyPlacesData()
                
                loadPOIsOnlyOnce = true
            }
        }
    }
}

// MARK: - ARDataSource Methods

extension NearbyPlacesViewController: ARDataSource {
    
    // plot customized marker on  Augmented Reality

    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        let annotationView = AnnotationView().loadView()
        annotationView.annotation = viewForAnnotation
        annotationView.delegate = self
        
        if let aPlace = viewForAnnotation as? Place {
            annotationView.lblTitle?.text = aPlace.placeName
            annotationView.lblDistance?.text = String(format: "%.2f km", aPlace.distanceFromUser / 1000)
            annotationView.ratingView.rating = aPlace.rating
            annotationView.imagePlace.layer.cornerRadius = 4
            
            // let imageUrl = URL.init(string: aPlace.imageUrl)
            // annotationView.imagePlace.sd_setImage(with: imageUrl!, placeholderImage: UIImage(named: "Placeholder"), options: .highPriority)
        }
        
        return annotationView
    }
}

extension NearbyPlacesViewController: AnnotationViewDelegate {
    func didTouch(annotationView: AnnotationView) {
        if let annotation = annotationView.annotation as? Place {
            self.aPlace = annotation
        }

        self.arViewController.dismiss(animated: false) {
            self.performSegue(withIdentifier: "DirectionViewController", sender: nil)
        }
    }
}

// MARK: - MarkerCustomInfoDelegate Methods

extension NearbyPlacesViewController: MarkerCustomInfoDelegate {

    func didTouchMap() {
        performSegue(withIdentifier: "DirectionViewController", sender: nil)
    }

}

// MARK: - GMSMapViewDelegate Methods

extension NearbyPlacesViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        googleMaps.isMyLocationEnabled = true
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        googleMaps.isMyLocationEnabled = true

        if (gesture) {
            mapView.selectedMarker = nil
        }
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        tappedMarker = marker
        googleMaps.isMyLocationEnabled = true
                
        if let myMarker = marker as? MyMarker {
            if let aPlace = myMarker.place {
                displayPlaceInformationAt(marker.position, aPlace: aPlace, for: mapView)
            }
        }
        return false
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        customInfoWindow?.removeFromSuperview()
    }

    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        googleMaps.isMyLocationEnabled = true
        googleMaps.selectedMarker = nil
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if let aPosition = tappedMarker?.position {
            customInfoWindow?.center = mapView.projection.point(for: aPosition)
            customInfoWindow?.center.y -= 100
        }
    }
}

