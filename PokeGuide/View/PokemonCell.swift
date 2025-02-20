//
//  PokemonCell.swift
//  PokeGuide
//
//  Created by t2023-m0072 on 12/30/24.
//

import UIKit
import Kingfisher

/// 메인 화면의 컬렉션 뷰 셀
final class PokemonCell: UICollectionViewCell {
    
    static let id = "PokemonCell"
    
    private var currentPokemonId: Int?
    
    /// 포켓몬 이미지
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.cellBackground
        imageView.layer.cornerRadius = 10
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    // 재사용 처리
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        currentPokemonId = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 컬렉션뷰 셀의 이미지를 그리는 메서드
    /// - Parameters:
    ///   - pokemonData: 셀에 들어갈 포켓몬의 데이터
    func setImage(_ pokemonData: PokemonData) {
        let url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemonData.id).png"
        // 이미지 로딩
        if let imageUrl = URL(string: url)  {
            imageView.kf.setImage(with: imageUrl)
        }
    }
    
    /// UI 셋업 메서드
    private func setupUI() {
        [
            imageView
        ].forEach { contentView.addSubview($0) }
        imageView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
}
