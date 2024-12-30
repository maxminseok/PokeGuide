//
//  DetailViewModel.swift
//  PokeGuide
//
//  Created by t2023-m0072 on 12/30/24.
//

import UIKit
import RxSwift

class DetailViewModel {
    
    private let disposeBag = DisposeBag()
    
    func fetchPoekemonDetailData(_ pokemonData: PokemonData) -> Single<PokemonDetail> {
        guard let url = URL(string: "\(pokemonData.url)") else {
            return Single.error(NetworkError.invalidUrl)
        }
        
        return NetworkManager.shared.fetch(url: url)
    }
}
