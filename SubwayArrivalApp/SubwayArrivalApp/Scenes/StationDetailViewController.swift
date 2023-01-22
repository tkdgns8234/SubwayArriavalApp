//
//  StationDetailViewController.swift
//  SubwayArrivalApp
//
//  Created by 정상훈 on 2023/01/21.
//
/**
 TODO:
 1. Timer 이용해서 1분 주기로 새로고침하기
 2. station 정보 동일한 역인 경우 하나의 역 + 도착정보를 표시하도록 수정 (filter 이용)
 */
import UIKit
import SnapKit
import Alamofire

final class StationDetailViewController: UIViewController {
    private let station: Station
    private var realTimeArrival: [StationArrivalDatResponseModel.RealTimeArrival] = []
    
    private lazy var refreshControll: UIRefreshControl = {
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        return refreshControll
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: view.frame.width - 32.0, height: 100.0) // 최소 사이즈
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(StationDetailViewCell.self, forCellWithReuseIdentifier: "StationDetailViewCell")
        
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControll
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = station.stationName
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        fetchData()
    }
    
    init(station: Station) {
        self.station = station
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func fetchData() {
        let stationName = station.stationName
        let urlString = "http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/\(stationName.replacingOccurrences(of: "역", with: ""))"
        AF
            .request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of: StationArrivalDatResponseModel.self) { [weak self] response in
                self?.refreshControll.endRefreshing()
                guard case .success(let data) = response.result else { return }
                
                self?.realTimeArrival = data.realtimeArrivalList
                self?.collectionView.reloadData()
            }
            .resume()
        
    }
}

extension StationDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realTimeArrival.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StationDetailViewCell", for: indexPath) as? StationDetailViewCell
        let info = realTimeArrival[indexPath.row]
        cell?.setup(with: info)
        
        return cell ?? UICollectionViewCell()
    }
}
