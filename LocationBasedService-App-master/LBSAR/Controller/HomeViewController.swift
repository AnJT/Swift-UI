//
//  HomeViewController.swift
//  LBSAR
//
//  Created by skj on 8.3.2020.
//  Copyright © 2020 skj. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    // googleMap支持的一些key
    var dataArr: [String: String] = ["cafe": "Cafe",
                                     "hospital": "Hospital",
                                     "supermarket": "Super Market",
                                     "school": "School",
                                     "amusement_park": "Amusement Park",
                                     "bank": "Banks",
                                     "pharmacy": "Pharmacy",
                                     "restaurant": "Restaurants",
                                     "bicycle_store": "Bicycle Store",
                                     "bus_station": "Bus Station",
                                     "car_rental": "Car Rental",
                                     "gas_station": "Gas Station"
                                    ]
    
    var keys = [String]()
    var data = [HomeItem]()

    let sectionInset:CGFloat = CGFloat(Constants.Preferences.collectionViewSectionInset)
    let minimumCellSpacing:CGFloat = CGFloat(Constants.Preferences.collectionViewMinmCellSpacing)
    var searchKey = ""
    var searchName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUIs()
        prepareData()
    }

    private func prepareData() {
        keys = Array(dataArr.keys)
        for key in keys {
            let homeItem = HomeItem()
            homeItem.itemTitle = dataArr[key]!
            homeItem.key = key
            data.append(homeItem)
        }
        // 异步加载
        collectionView.reloadData()
    }

    private func configureUIs() {
        // 设置圆角
        collectionView.layer.cornerRadius = 5
        // 设置背景颜色
        collectionView.backgroundColor = UIColor(red: 252, green: 252, blue: 252)
        // 根据safeAreaInsets超出范围进行调整
        collectionView.contentInsetAdjustmentBehavior = .automatic

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // 设置边距
        layout.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
        // 与滚动方向相反的间距
        layout.minimumInteritemSpacing = minimumCellSpacing
        // 与滚动方向相同的间距
        layout.minimumLineSpacing = minimumCellSpacing + 10
        collectionView.collectionViewLayout = layout
    }

    // MARK: - Navigation

    // 跳转至NearbyPlaces时传值调用
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let aDestinationVC = segue.destination as? NearbyPlacesViewController {
            let aHomeItem = sender as! HomeItem
            aDestinationVC.aHomeItem = aHomeItem
        }
    }

}

extension HomeViewController: UICollectionViewDataSource {
    // 总数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys.count
    }
    
    // 每个cell填充HomeCell并设置homeItem
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        let aHomeItem = data[indexPath.row]
        cell.homeItem = aHomeItem
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout delegate methods

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    // 设置指定cell的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = UIScreen.main.bounds.size.width
        // 如果是横屏
        if UIDevice.current.orientation.isLandscape {
            return CGSize(width: (width - 20 - sectionInset * 2 - minimumCellSpacing * 3)/6, height: (width - 20 - sectionInset * 2 - minimumCellSpacing * 3)/6)
        }
        // 竖屏
        return CGSize(width: (width - 20 - sectionInset * 2 - minimumCellSpacing * 3)/3, height: (width - 20 - sectionInset * 2 - minimumCellSpacing * 3)/3)
    }

}

// MARK: UICollectionViewDelegate delegate methods

extension HomeViewController: UICollectionViewDelegate {
    // 当指定indexPath处的cell被选择时触发跳转界面
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let aHomeItem = data[indexPath.row]
        performSegue(withIdentifier: "NearbyPlacesViewController", sender: aHomeItem)
    }
}

