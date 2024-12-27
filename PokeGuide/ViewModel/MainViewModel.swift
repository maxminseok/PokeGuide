//
//  MainViewModel.swift
//  PokeGuide
//
//  Created by t2023-m0072 on 12/27/24.
//

import Foundation
import RxSwift

class MainViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let limit = 20
    private let offset = 0
    
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
    
    
    
    
    
    
}
