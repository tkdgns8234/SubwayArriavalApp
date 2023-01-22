//
//  StationDetailViewCell.swift
//  SubwayArrivalApp
//
//  Created by 정상훈 on 2023/01/21.
//

import UIKit
import SnapKit

class StationDetailViewCell: UICollectionViewCell {
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        
        return label
    }()
    
    private lazy var remainTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .medium)
        
        return label
    }()
    
    func setup(with info: StationArrivalDatResponseModel.RealTimeArrival) {
        layer.cornerRadius = 12.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10.0
        
        backgroundColor = .systemBackground // 배경색이 없는상태에서 위 섀도우 설정하면 섀도우 설정이 재대로 안됨
        
        [mainLabel, remainTimeLabel].forEach { addSubview($0) }
        mainLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.top.equalToSuperview().inset(16.0)
        }
        remainTimeLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(16.0)
            $0.leading.equalTo(mainLabel.snp.leading)
            $0.bottom.equalToSuperview().inset(16.0)
        }
        
        mainLabel.text = info.line
        remainTimeLabel.text = info.remainTime
    }
}
