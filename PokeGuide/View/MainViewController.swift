//
//  ViewController.swift
//  PokeGuide
//
//  Created by t2023-m0072 on 12/27/24.
//

import UIKit
import RxSwift
import SnapKit

// 사용한 컬러 hex 값.
extension UIColor {
    static let mainRed = UIColor(red: 190/255, green: 30/255, blue: 40/255, alpha: 1.0)
    static let darkRed = UIColor(red: 120/255, green: 30/255, blue: 30/255, alpha: 1.0)
    static let cellBackground = UIColor(red: 245/255, green: 245/255, blue: 235/255, alpha: 1.0)
}

class MainViewController: UIViewController {
    
    private let mainViewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    private var pokemonData = [PokemonData]()
    
    private let pokemonballImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pokemonBall")
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.darkRed
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureUI()
    }
    
    private func bind() {
        mainViewModel.pokemonSubject
            .subscribe(onNext: { [weak self] pokemon in
                self?.pokemonData = pokemon
                self?.collectionView.reloadData()
            }, onError: { error in
                print("에러 발생 : \(error)")
            }).disposed(by: disposeBag)
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.mainRed
        [
            pokemonballImageView,
            collectionView
        ].forEach { view.addSubview($0) }
        
        pokemonballImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(pokemonballImageView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // detailViewController로 이동
//        let selectedCell = pokemonData[indexPath.row]
//        let detailVC = detailViewController()
//        detailVC.setDetailViewData(selectedCell)
//        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.id, for: indexPath) as? PokemonCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(pokemonData[indexPath.row])
        return cell
    }
    
    
}
