//
//  NetworkManager.swift
//  PokeGuide
//
//  Created by t2023-m0072 on 12/27/24.
//

import UIKit
import RxSwift

enum NetworkError: Error {
    case invalidUrl
    case dataFetchfail
    case decodingFail
    case invalidData
}

/// 서버에서 데이터를 받아오기 위한 네트워크 매니저 클래스
class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    /// 서버에서 데이터를 받아오는 일반적인 형태의 메서드
    /// - Parameter url: 요청을 보낼 url
    /// - Returns: 반환 데이터를 Single 형태로 방출
    func fetch<T: Decodable>(url: URL) -> Single<T> {
        return Single.create { observer in
            let session = URLSession(configuration: .default)
            session.dataTask(with: URLRequest(url: url)) { data, response, error in
                // 네트워크 요청 중 에러 발생 여부 확인
                if let error = error {
                    observer(.failure(error))
                    return
                }
                // 응답 데이터 상태 코드 200~299 범위인지 확인(성공인지 확인)
                guard let data = data,
                      let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) else {
                    observer(.failure(NetworkError.dataFetchfail))
                    return
                }
                
                // 디코딩
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    observer(.success(decodedData))
                } catch {
                    observer(.failure(NetworkError.decodingFail))
                }
            }.resume()
            return Disposables.create()
        }
    }
}
