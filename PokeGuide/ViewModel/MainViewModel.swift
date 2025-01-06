//
//  MainViewModel.swift
//  PokeGuide
//
//  Created by t2023-m0072 on 12/27/24.
//

import UIKit
import RxSwift
import RxCocoa


class MainViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let limit = 20
    private var offset = 0
    private var isFetching = false // 중복 호출 방지 플래그
    private var hasMoreData = true // 추가 데이터 유무 확인 플래그
    
    // view가 구독할 subject
    let pokemonSubject = BehaviorSubject(value: [PokemonData]())
    let noMoreDataSubject = PublishSubject<Void>()
    
    init() {
        fetchPokemonData(reset: true) // 초기 데이터 로드하도록 설정
    }
    
    // 포켓몬 데이터를 받아오는 메서드
    func fetchPokemonData(reset: Bool) {
        // 초기 데이터 로드(true)인지 추가 데이터 로드(false)인지 확인
        if reset {
            offset = 0
            hasMoreData = true
        }
        guard !isFetching, hasMoreData else { return }
        isFetching = true
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
            pokemonSubject.onError(NetworkError.invalidUrl)
            isFetching = false
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (pokemonList: PokemonList) in
                guard let self = self else { return }
                
                // 로드 된 데이터 있는지 확인
                if pokemonList.results.isEmpty {
                    self.hasMoreData = false // 없을 경우 플래그 false
                    self.noMoreDataSubject.onNext(())
                }
                // 로드 된 데이터 있을 경우
                else {
                    // 초기 데이터 로드 일 경우
                    if reset {
                        self.pokemonSubject.onNext(pokemonList.results)
                    }
                    // 스크롤 하여 추가 로드하는 경우
                    else {
                        var currentData = (try? self.pokemonSubject.value()) ?? []
                        currentData.append(contentsOf: pokemonList.results)
                        self.pokemonSubject.onNext(currentData)
                    }
                }
                // 오프셋 증가
                self.offset += self.limit
                // 데이터 로드 후 중복 호출 방지 플래그 false
                self.isFetching = false
            }, onFailure: { error in
                print("데이터 로드 실패: \(error)")
                self.isFetching = false
            }).disposed(by: disposeBag)
    }
}
