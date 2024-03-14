# Everyminute 🕰️👨‍💻
![everyminute](https://github.com/yeonupark/MessengerProject/assets/130972950/40d99459-0a81-44e1-95cb-ad80f51b117c)

## 한 줄 소개
공통된 작업을 목표로 하는 팀원들 간의 커뮤니티를 구성하여 팀 협업을 원활하게 돕는 어플로, 회원 인증부터 채널 기반의 채팅까지 모든 과정을 통합하여 제공합니다.

## 핵심 기능
- 회원 인증을 거친 소셜 로그인, 로컬 로그인이 가능하며, 로그인 이후 일정 기간 내에는 토큰 갱신을 통해 로그인 상태가 자동으로 유지 및 연장됨.
- 개인 프로필 구성이 가능하며 팀원들 간 프로필을 확인할 수 있음.
- 커뮤니티의 기반이 되는 워크스페이스 생성, 수정, 삭제가 가능함.
- 워크스페이스 내에서 작업 단위 혹은 주제 별로 채널을 생성하고 팀원을 초대할 수 있음.
- 채널 내 팀원들 간 채팅이 가능함. 채팅은 Realm 데이터베이스에 저장되며, 새로운 채팅 메시지를 전송할 때는 SocketIO를 통해 실시간으로 팀원들에게 전달됨.

## 개발 기간
2024.01.06 ~ 2024.02.06 (4주)

## 기술 스택 및 라이브러리
- SwiftUI, PhotosUI
- Combine
- AuthenticationServices
- MVVM, Repository
- Moya
- SocketIO
- APNS
- Realm
- UserDefaults, Extension, Protocol, Closure, Codable, UUID
- Firebase Cloud Messaging
- KakaoSDKUser

## 고민한 지점
- 커스텀 폰트를 적용할 때, 폰트의 line height를 직접 지정하는 기능이 제공되지 않음

  &rarr; ViewModifier 구조체를 생성하고 View extension을 활용하여 커스텀 폰트의 line height를 지정하는 방법을 선택함

```swift
struct FontWithLineHeight: ViewModifier {
    let font: UIFont
    let lineHeight: CGFloat

    func body(content: Content) -> some View {
        content
            .font(Font(font))
            .lineSpacing(lineHeight - font.lineHeight)
            .padding(.vertical, (lineHeight - font.lineHeight) / 2)
    }
}

extension View {
    func fontWithLineHeight(font: UIFont, lineHeight: CGFloat) -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: font, lineHeight: lineHeight))
    }
}
```
  
- 화면 전환이 여러번 이루어지면서 이로 인해 뷰 계층이 여러 번 겹쳐져 원치 않는 뷰들이 쌓여있는 것이 확인됨

  &rarr; 최상위 뷰에서 상태 및 조건을 관리하여 루트 뷰를 변경하는 방식을 선택

```swift
struct InitialView: View {
    
    @ObservedObject var viewModel = HomeViewModel()
    
    @State var isNewUser = false
    
    var body: some View {
        
        if viewModel.isLogout {
            OnboardingView(isRootViewOnboardingView: $viewModel.isLogout, isNewUser: $isNewUser)
                .onAppear() {
                    viewModel.tokenRefresh()
                }
        } else {
            HomeView(isNewUserResult: $isNewUser, isLogout: $viewModel.isLogout)
        }
    }
}
```

## 회고
- 뿌듯한 점 ☺️
  1. 이번 프로젝트를 통해 SwiftUI를 활용한 첫 서비스를 구현해 볼 수 있었다. 기존의 UIKit과는 다른 접근 방식을 통해 UI를 구성하면서 UI 개발이 보다 직관적이고 빠르게 이루어지는 것을 실감했다. 또한 @State, @Binding 등을 통해 뷰의 상태를 관리하고 효율적인 방식으로 데이터 흐름을 제어하는 방식을 새롭게 익힐 수 있었다.
  2. Combine 프레임워크를 학습하고 구현하며 비동기적인 데이터 스트림의 처리를 보다 간편하게 구현할 수 있었고, 데이터 흐름을 더욱 명확하게 관리할 수 있었다. Combine을 사용하며 코드의 가독성과 유지보수성 향상에 대한 관심을 더욱 키우게 되었다.
  3. ScrollView Reader, Tap Gesture 등을 적극적으로 활용하여 사용자의 편의성을 고려한 UI/UX 디자인과 상호작용 기능을 구현함으로써 사용자에게 보다 편리하고 직관적인 서비스를 제공할 수 있었다.

- 아쉬운 점 🥲
  1. 프로젝트를 진행하면서 Combine을 직접 사용하며 감을 익힐 수 있었지만 다양한 연산자를 활용하는 단계로 나아가기엔 부족했던 것 같다. Combine 프레임워크의 다양한 연산자들을 보다 깊이 있게 이해하고 활용하기 위해 추가적인 학습이 필요하다고 생각한다.
  2. Enum으로 API 요청 결과에 대한 에러 처리를 구현하는 등 Enum을 보다 적극적으로 활용하여 조금 더 깔끔하고 가독성 있는 코드를 작성했으면 좋았을 것이다. 
