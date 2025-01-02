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
    private var isFetchingData = false
    
    private var pokemonData = [PokemonData]()
    
    private let pokemonballImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pokemonBall")
        imageView.backgroundColor = UIColor.mainRed
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
            .observe(on: MainScheduler.instance)
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
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            $0.width.height.equalTo(UIScreen.main.bounds.width * 0.3)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(pokemonballImageView.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    // 셀 선택 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // detailViewController로 이동
        let selectedCell = pokemonData[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.setDetailViewData(selectedCell)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // 스크롤 감지 메서드
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y // 현재 스크롤된 Y 좌표
        let contentHeight = scrollView.contentSize.height // 스크롤 되어야 하는 컨텐츠의 총 높이
        let height = scrollView.frame.size.height // 화면에 보이는 스크롤뷰의 높이
        
        // 하단에 도달했을 때 새로운 데이터 로드하기
        if offsetY > contentHeight - height - 100 && contentHeight > height {
            fetchMoreData()
        }
    }
    
    // 무한 스크롤 구현 메서드
    private func fetchMoreData() {
        guard !isFetchingData else { return } // 메서드 중복 호출 방지
        isFetchingData = true
        
        mainViewModel.fetchPoekemonData(reset: false)
        isFetchingData = false
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
        
        cell.configure(pokemonData[indexPath.row], mainViewModel)
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    // 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3 // 가로로 배치할 셀 개수
        let spacing: CGFloat = 10
        let totalSpacing = (itemsPerRow - 1) * spacing // 전체 간격 계산
        let width = (collectionView.frame.width - totalSpacing - 20) / itemsPerRow // 셀 너비 계산
        return CGSize(width: floor(width), height: floor(width))
    }

    // 행 간 간격 설정
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // 여백 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let spacing: CGFloat = 10
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    // 열 간 간격 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
