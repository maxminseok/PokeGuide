//
//  DetailViewModel.swift
//  PokeGuide
//
//  Created by t2023-m0072 on 12/30/24.
//

import UIKit
import RxSwift

class DetailViewModel {
    
    func fetchPoekemonDetailData(_ pokemonData: PokemonData) -> Single<PokemonDetail> {
        guard let url = URL(string: "\(pokemonData.url)") else {
            return Single.error(NetworkError.invalidUrl)
        }
        return NetworkManager.shared.fetch(url: url)
    }
    
    func fetchPokemonImage(_ pokemonData: PokemonData) -> Single<UIImage> {
        guard let imageUrl = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemonData.id).png") else {
            return Single.error(NetworkError.invalidUrl)
        }
        return NetworkManager.shared.fetchImage(imageUrl)
    }
}
