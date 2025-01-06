//
//  ViewController.swift
//  PokeGuide
//
//  Created by t2023-m0072 on 12/27/24.
//

import UIKit
import RxSwift
import SnapKit
import RxCocoa

final class MainViewController: UIViewController {
    
    private let mainViewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    private var pokemonData = [PokemonData]()
    
    //MARK: - UI 컴포넌트 선언
    
    /// 포켓몬볼 이미지 뷰
    private let pokemonBallImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pokemonBall")
        imageView.backgroundColor = UIColor.mainRed
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    /// 포켓몬 이미지를 띄울 컬렉션 뷰
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.id)
        collectionView.backgroundColor = UIColor.darkRed
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureUI()
    }

//MARK: - 메서드 선언
    
    /// 데이터 바인딩 메서드
    private func bind() {
        
        // 컬렉션 뷰 셀 선택 이벤트 전달
        collectionView.rx.itemSelected
            .bind(to: mainViewModel.cellSelectedRelay)
            .disposed(by: disposeBag)
        
        // 셀 선택 핸들링
        mainViewModel.cellSelectedRelay
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                guard let selectedData = try? self.mainViewModel.pokemonSubject.value()[indexPath.row] else { return }
                
                let detailVC = DetailViewController()
                detailVC.setDetailViewData(selectedData)
                self.navigationController?.pushViewController(detailVC, animated: true)
            }).disposed(by: disposeBag)
        
        // 스크롤 이벤트 전달
        collectionView.rx.contentOffset
            .bind(to: mainViewModel.scrollRelay)
            .disposed(by: disposeBag)

        // 포켓몬 데이터 바인딩
        mainViewModel.pokemonSubject
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: PokemonCell.id, cellType: PokemonCell.self)) { index, data, cell in
                cell.setImage(data)
            }.disposed(by: disposeBag)

        // 데이터 유무 확인하는 subject 바인딩
        mainViewModel.noMoreDataSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.showNoMoreAlert() // 더이상 데이터 없을 때 Alert
                self?.collectionView.bounces = false    // 데이터 없을 떄 스크롤 바운스 효과 비활성화
            }).disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
         
    }
    
    /// UI 레이아웃 메서드
    private func configureUI() {
        view.backgroundColor = UIColor.mainRed
        [
            pokemonBallImageView,
            collectionView
        ].forEach { view.addSubview($0) }
        
        pokemonBallImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            $0.width.height.equalTo(UIScreen.main.bounds.width * 0.3)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(pokemonBallImageView.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    /// Alert 메서드
    private func showNoMoreAlert() {
        let alert = UIAlertController(title: "알림", message: "더이상 포켓몬 데이터가 없습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

//MARK: - 컬렉션 뷰 셀 설정
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
