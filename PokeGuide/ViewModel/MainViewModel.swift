//
//  MainViewModel.swift
//  PokeGuide
//
//  Created by t2023-m0072 on 12/27/24.
//

import UIKit
import RxSwift

class MainViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let limit = 20
    private var offset = 0
    private var isFetching = false // 중복 호출 방지 플래그
    private var hasMoreData = true // 추가 데이터 여부 플래그
    
    // view가 구독할 subject
    let pokemonSubject = BehaviorSubject(value: [PokemonData]())
    
    init() {
        fetchPoekemonData()
    }
    
    // 포켓몬 데이터 불러오기
    func fetchPoekemonData() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
            pokemonSubject.onError(NetworkError.invalidUrl)
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (pokemonList: PokemonList) in
                self?.pokemonSubject.onNext(pokemonList.results)
            }, onFailure: { [weak self] error in
                self?.pokemonSubject.onError(error)
            }).disposed(by: disposeBag)
    }
    
    // 포켓몬 이미지 불러오기
    func fetchPokemonImage(_ pokemonData: PokemonData) -> Single<UIImage> {
        guard let imageUrl = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemonData.id).png") else {
            return Single.error(NetworkError.invalidUrl)
        }
        return NetworkManager.shared.fetchImage(imageUrl)
    }
    
    // 포켓몬 데이터 새로 불러오기
    func fetchMorePokemonData() {
        guard !isFetching, hasMoreData else { return } // 추가 데이터가 없거나 중복 호출 방지
        
        isFetching = true // 메서드 동작시 플래그 true
        
        offset += limit // 오프셋 파라미터 증가
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
            pokemonSubject.onError(NetworkError.invalidUrl)
            isFetching = false // url 에러시 플래그 초기화하고 종료
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (pokemonList: PokemonList) in
                // 새 데이터 여부 확인
                if pokemonList.results.isEmpty {
                    self?.hasMoreData = false // 더이상 데이터 없을 시 플래그 false
                } else {
                    // 기존 데이터에 새로운 데이터 추가
                    var currentData = (try? self?.pokemonSubject.value()) ?? []
                    currentData.append(contentsOf: pokemonList.results)
                    self?.pokemonSubject.onNext(currentData)
                }
                
                self?.isFetching = false // 새 데이터 호출 후 플래그 초기화
            }, onFailure: { [weak self] error in
                print("새 데이터 fetch 에러: \(error)")
                self?.isFetching = false
            }).disposed(by: disposeBag)
    }
    
}
