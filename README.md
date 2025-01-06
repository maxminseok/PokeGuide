# 📚 프로젝트 소개 
Rest API와 RxSwift를 활용해 MVVM 구조의 포켓몬 도감앱 만들기

---

# 📌 요구 사항
- Lv 1 : NetworkManager 구현
- Lv 2 : MVVM 중에서 Model을 구현
- Lv 3 : MainViewModel 구현
- Lv 4 : MainViewController 구현
- Lv 5 : CollectionViewCell 을 클릭했을 때 화면 전환
- Lv 6 : DetailViewModel 구현
- Lv 7 : DetailViewController 구현
- Lv 8 : 무한 스크롤 구현

---

# 🎬 앱 미리보기
## 메인 화면
<img src="https://github.com/user-attachments/assets/ced58eda-185d-4c73-b009-de3087628dd6" width="40%" height="40%">

## 세부 정보 화면
<img src="https://github.com/user-attachments/assets/37ce4c95-1fd9-4980-9a71-5016f035b481" width="40%" height="40%">

## 더이상 데이터 없을 때까지 무한 스크롤
<img src="https://github.com/user-attachments/assets/cb802d78-5b7a-4ded-8519-13d54eef1d4e" width="40%" height="40%">

---

# 🔎 파일 구성
## Model 폴더
각종 데이터를 저장할 구조체와 서버 통신을 위환 메서드가 구현되어 있는 폴더입니다.
- PokemonDetail : 포켓몬의 세부 정보를 저장할 구조체가 있습니다.
- PokemonList : 포켓몬의 기본 정보를 저장할 구조체가 있습니다.
- PokemonTranslator : 포켓몬의 이름을 한글로 번역하기 위한 딕셔너리와 메서드가 있습니다.
- PokemonTypeName : 포켓몬의 타입을 한글로 번역하기 위한 enum이 정의되어 있습니다.

## View 폴더
포켓몬 목록을 띄울 메인 화면과 특정 포켓몬의 세부 정보를 띄우기 위한 세부 화면을 구현하기 위한 ViewController가 있는 폴더입니다.
- MainViewController : UICollectionView로 포켓몬 이미지를 띄우는 뷰가 구현된 UIViewController 입니다.
- DetailViewController : 선택 된 포켓몬의 세부 정보를 띄우는 뷰가 구현된 UIViewController 입니다.
- PokemonCel : 메인 뷰를 구현한 MainViewController의 UICollectionView에 대한 UICollectionViewCell이 구현되어 있습니다.

## ViewModel 폴더
포켓몬 데이터를 서버로부터 받아오고, 뷰에 띄우기 위한 비지니스 로직이 구현된 뷰모델 폴더입니다.
- MainViewModel : 메인 뷰인 MainViewController에 포켓몬 이미지를 띄울 수 있도록 RxSwift의 Subject 데이터를 방출하는 뷰모델 입니다.
- DetailViewModel : 포켓몬 세부 정보 뷰인 DetailViewController에 세부 데이터를 띄울 수 있도록 RxSwift의 Single 데이터를 방출하는 뷰모델 입니다.

## NetworkManager
서버로부터 포켓몬 데이터를 받아서 RxSwift의 Single 데이터를 방출하는 네트워크 매니저 입니다.

---

# 🙏 커밋 컨벤션
- [ADD] : 파일 추가
- [RENAME] : 파일 혹은 폴더명을 수정하거나 옮기는 작업만인 경우
- [REMOVE] : 파일을 삭제하는 작업만 수행한 경우
- [FEAT] : 기능 추가
- [DELETE] : 기능 삭제
- [UPDATE] : 기능 수정
- [FIX] : 버그 수정
- [REFACTOR] : 리팩토링
- [CHORE] : 기타 변경사항 (빌드 스크립트 수정, 에셋 추가 등)
- [COMMENT] : 필요한 주석 추가 및 변경

---
# 🛠️ 트러블슈팅
[트러블 슈팅](https://velog.io/@maxminseok/%ED%8F%AC%EC%BC%93%EB%AA%AC-%EB%8F%84%EA%B0%90%EC%95%B1-4)
