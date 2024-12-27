//
//  PokemonList.swift
//  PokeGuide
//
//  Created by t2023-m0072 on 12/27/24.
//

import Foundation

struct PokemonList: Codable {
    let results: [PokemonData]
}

struct PokemonData: Codable {
    let name: String
    let url: String
    
    // url에서 id 추출
    var id: Int {
        Int(url.split(separator: "/").last ?? "0") ?? 0
    }
}
