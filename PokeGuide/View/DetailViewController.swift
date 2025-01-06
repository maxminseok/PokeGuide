//
//  DetailViewController.swift
//  PokeGuide
//
//  Created by t2023-m0072 on 12/30/24.
//

import UIKit
import RxSwift
import SnapKit

/// 포켓몬 상세 정보를 띄울 DetailView
final class DetailViewController: UIViewController {
    
    private let detailViewModel = DetailViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - UI 컴포넌트 선언
    
    /// 포켓몬 정보를 띄울 배경 뷰
    private let pokemonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkRed
        view.layer.cornerRadius = 10
        return view
    }()
    
    /// 포켓몬 이미지뷰
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.darkRed
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    /// 포켓몬 번호와 이름 스택뷰
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    /// 포켓몬 정보 스택뷰
    private let dataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    /// 포켓몬 번호 레이블
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "No."
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    /// 포켓몬 이름 레이블
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    /// 포켓몬 타입 레이블
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "타입: "
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    /// 포켓몬 키 레이블
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "키: "
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    /// 포켓몬 몸무게 레이블
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "몸무게: "
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - 메서드 선언
    
    /// UI 셋업 메서드
    private func configureUI() {
        view.backgroundColor = UIColor.mainRed
        
        // 배경 뷰 추가
        view.addSubview(pokemonView)
        
        // 배경 뷰에 이미지와 스택뷰 추가
        [
            pokemonImageView,
            nameStackView,
            dataStackView,
        ].forEach { pokemonView.addSubview($0)}
        
        // 번호와 이름을 horizontal 스택뷰에 추가
        [
            numberLabel,
            nameLabel,
        ].forEach { nameStackView.addArrangedSubview($0) }
        
        // 타입, 키, 몸무게를 vertical 스택뷰에 추가
        [
            typeLabel,
            heightLabel,
            weightLabel,
        ].forEach { dataStackView.addArrangedSubview($0) }
        
        pokemonView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.6)
        }
        
        pokemonImageView.snp.makeConstraints {
            $0.top.equalTo(pokemonView.snp.top).offset(40)
            $0.centerX.equalTo(pokemonView.snp.centerX)
            $0.width.height.equalTo(pokemonView.snp.width).multipliedBy(0.6)
        }
        
        nameStackView.snp.makeConstraints{
            $0.top.equalTo(pokemonImageView.snp.bottom).offset(12)
            $0.centerX.equalTo(pokemonView.snp.centerX)
            $0.height.equalTo(pokemonImageView.snp.height).multipliedBy(0.25)
        }
        
        dataStackView.snp.makeConstraints {
            $0.top.equalTo(nameStackView.snp.bottom).offset(8)
            $0.centerX.equalTo(pokemonView.snp.centerX)
            $0.width.equalTo(nameStackView.snp.width)
        }
    }
    
    /// 디테일 뷰 UI 업데이트 메서드
    /// - Parameter pokemonData: 선택된 셀의 포켓몬 데이터
    func setDetailViewData(_ pokemonData: PokemonData) {
        let url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemonData.id).png"
        // 이미지 로딩
        if let imageUrl = URL(string: url)  {
            pokemonImageView.kf.setImage(with: imageUrl)
        }
        
        // 포켓몬 데이터 바인딩
        detailViewModel.fetchPoekemonDetailData(pokemonData)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] pokemonDetail in
                self?.nameLabel.text = PokemonTranslator.getKoreanName(for: pokemonDetail.name)
                self?.numberLabel.text = "No.\(pokemonDetail.id)"
                self?.heightLabel.text = String(format: "키: %.1f m", Double(pokemonDetail.height) / 10.0)
                self?.weightLabel.text = String(format: "몸무게: %.1f kg", Double(pokemonDetail.weight) / 10.0)
                self?.typeLabel.text = "타입: " + pokemonDetail.types.map { $0.type.name.displayName }.joined(separator: ", ")
            }, onError: { error in
                print("데이터 에러: \(error)")
            }).disposed(by: disposeBag)
    }
}
