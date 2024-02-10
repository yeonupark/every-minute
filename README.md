# Everyminute
![everyminute](https://github.com/yeonupark/MessengerProject/assets/130972950/40d99459-0a81-44e1-95cb-ad80f51b117c)

## 한 줄 소개
공통된 작업을 목표로 하는 팀원들 간의 커뮤니티를 구성하여 팀 협업을 원활하게 돕는 어플로, 회원 인증부터 채널 기반의 채팅까지 모든 과정을 통합하여 제공합니다.

## 핵심기능
- 회원 인증을 거친 소셜 로그인, 로컬 로그인이 가능하며, 로그인 이후 일정 기간 내에는 토큰 갱신을 통해 로그인 상태가 자동으로 유지 및 연장됨
- 개인 프로필 구성이 가능하며 팀원들 간 프로필을 확인할 수 있음
- 커뮤니티의 기반이 되는 워크스페이스 생성, 수정, 삭제가 가능함
- 워크스페이스 내에서 작업 단위 혹은 주제 별로 채널을 생성하고 팀원을 초대할 수 있음
- 채널 내 팀원들 간 채팅이 가능함. 채팅은 Realm 데이터베이스에 저장되며, 새로운 채팅 메시지를 전송할 때는 SocketIO를 통해 실시간으로 팀원들에게 전달됨.

## 개발 기간
2024.01.06 ~ 2024.02.06 (4주)

## 기술 스택 및 라이브러리
- SwiftUI, PhotosUI
- Combine
- MVVM, Repository
- Moya
- SocketIO
- Realm
- Kingfisher
- UserDefaults, Extension, Protocol, Closure, Codable, UUID
