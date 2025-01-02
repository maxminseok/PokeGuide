//
//  PokemonCell.swift
//  PokeGuide
//
//  Created by t2023-m0072 on 12/30/24.
//

import UIKit
import RxSwift
import RxCocoa

class PokemonCell: UICollectionViewCell {
    
    static let id = "PokemonCell"
    private var disposeBag = DisposeBag()
    private var currentPokemonId: Int?
    
    // 포켓몬 이미지
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.cellBackground
        imageView.layer.cornerRadius = 10
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
    
    func configure(_ pokemonData: PokemonData, _ viewModel: MainViewModel) {
        let pokemonId = pokemonData.id
        currentPokemonId = pokemonId // 현재 포켓몬 id 저장
        
        // 이미지 로딩
        viewModel.fetchPokemonImage(pokemonData)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] image in
                guard self?.currentPokemonId == pokemonId else { return } // 셀이 재사용 되지 않았는지 확인
                self?.imageView.image = image
            }, onError: { error in
            print("이미지 에러: \(error)")
            }).disposed(by: disposeBag)
    }
    
    private func setupUI() {
        [
            imageView
        ].forEach { contentView.addSubview($0) }
        imageView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
}
