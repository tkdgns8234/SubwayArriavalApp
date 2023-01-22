//
//  StationArrivalResponseModel.swift
//  SubwayArrivalApp
//
//  Created by 정상훈 on 2023/01/22.
//

import Foundation

struct StationArrivalDatResponseModel: Decodable {
    var realtimeArrivalList: [RealTimeArrival] = []

    struct RealTimeArrival: Decodable {
        let line: String // e.g 서울행
        let remainTime: String // e.g 도착까지 남은 시간 or 전역 출발
        let currentStation: String // e.g 현재 위치

        enum CodingKeys: String, CodingKey {
            case line = "trainLineNm"
            case remainTime = "arvlMsg2"
            case currentStation = "arvlMsg3"
        }
    }
}

