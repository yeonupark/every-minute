# Everyminute 🕰️👨‍💻
<img src = "https://github.com/yeonupark/ShoppingProject/assets/130972950/a6f1aec5-9393-48ad-aa5e-93feaa704565" width="23%" height="23%">
<img src = "https://github.com/yeonupark/ShoppingProject/assets/130972950/96726cf2-e806-4d5d-9dd2-9e20f2a9acc6" width="23%" height="23%">
<img src = "https://github.com/yeonupark/ShoppingProject/assets/130972950/0f608100-d886-4632-af52-084461b815a6" width="23%" height="23%">
<img src = "https://github.com/yeonupark/ShoppingProject/assets/130972950/ed388979-ac5f-4e11-94d6-1c984b63397e" width="23%" height="23%">


## 한 줄 소개
공통된 작업을 목표로 하는 팀원들 간의 커뮤니티를 구성하여 팀 협업을 원활하게 돕는 어플로, 회원 인증부터 채널 기반의 채팅까지 모든 과정을 통합하여 제공합니다.

## 개발 기간
2024.01.06 ~ 2024.02.06 (4주)

## 기능 소개
- 회원 인증을 거친 소셜 로그인, 로컬 로그인이 가능하며, 로그인 이후 일정 기간 내에는 토큰 갱신을 통해 로그인 상태가 자동으로 유지 및 연장됨
- 개인 프로필 구성이 가능하며 팀원들 간 프로필을 확인할 수 있음
- 커뮤니티의 기반이 되는 워크스페이스 생성, 수정, 삭제가 가능함
- 워크스페이스 내에서 작업 단위 혹은 주제 별로 채널을 생성하고 팀원을 초대할 수 있음
- 채널 내 팀원들 간 실시간 채팅이 가능하며 채팅 수신 시 푸시 알림을 받게됨

## 기술 스택 및 라이브러리
- SwiftUI, PhotosUI
- Combine
- AuthenticationServices
- MVVM
- Moya
- SocketIO
- RealmSwift
- APNs, Firebase Cloud Messaging
- KakaoSDKUser

## 핵심 기술
- SwiftUI와 Combine을 활용하여 비동기 작업 처리 및 반응형 UI 구현
  화면 간 이동 및 데이터 전달을 @State, @Binding 등의 property wrapper를 사용하여 쉽게 처리
- DragGesture를 통해 사용자의 상호작용에 반응하는 기능을 구현하여 사용자 경험 개선
- 채팅은 RealmDB에 저장되어 관리되며, 새로운 채팅 메시지를 전송할 때는 SocketIO를 통해 실시간으로 팀원들에게 전달
- FCM과 APNs를 활용하여 새로운 채팅을 받을 시 사용자에게 실시간으로 푸시 알림 전송
- AuthenticationServices를 사용한 애플 로그인과 KakaoSDKUser를 활용한 카카오 로그인 구현

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
