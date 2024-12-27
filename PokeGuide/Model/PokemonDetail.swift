//
//  PokemonDetail.swift
//  PokeGuide
//
//  Created by t2023-m0072 on 12/27/24.
//

import Foundation

struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let weight: Int
    let height: Int
    let types: [Types]
}

struct Types: Codable {
    let type: String
}
