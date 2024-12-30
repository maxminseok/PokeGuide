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
    let disposeBag = DisposeBag()
    private let mainViewModel = MainViewModel()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.cellBackground
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ pokemonData: PokemonData) {
        mainViewModel.fetchPokemonImage(pokemonData)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] image in
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
