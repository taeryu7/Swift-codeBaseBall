//
//  main.swift
//  BaseBall
//
//  Created by on 11/5/24.
//
// main.swift

import Foundation

/// 게임 기록을 저장하는 구조체
struct GameRecord {
    let attempts: Int
}

/// 게임의 전체 기록을 관리하는 클래스
class GameHistory {
    private var records: [GameRecord] = []
    
    /// 새로운 게임 기록 추가
    func addRecord(attempts: Int) {
        records.append(GameRecord(attempts: attempts))
    }
    
    /// 모든 게임 기록 조회
    func showRecords() {
        if records.isEmpty {
            print("\n아직 게임 기록이 없습니다.")
            return
        }
        
        print("\n< 게임 기록 보기 >")
        for (index, record) in records.enumerated() {
            print("\(index + 1)번째 게임 : 시도 횟수 - \(record.attempts)")
        }
        print()
    }
}

/// 메뉴 옵션을 나타내는 열거형
enum MenuOption: Int {
    case startGame = 1
    case showRecords = 2
    case exit = 3
}

/// 게임 메뉴를 표시하고 사용자 입력을 받는 함수
func showMenu() -> MenuOption? {
    print("\n[ 숫자 야구 게임 ]")
    print("1. 게임 시작하기")
    print("2. 게임 기록 보기")
    print("3. 종료하기")
    print("선택해주세요: ", terminator: "")
    
    guard let input = readLine(),
          let number = Int(input),
          let option = MenuOption(rawValue: number) else {
        return nil
    }
    
    return option
}

/// 숫자야구 게임을 실행하는 메인 함수
func playGame() -> Int? {
    print("\n게임을 시작합니다!")
    print("서로 다른 3자리 숫자를 맞혀보세요.")
    
    let game = BaseballGame()
    
    // 정답 확인하기 (테스트용) 추후 삭제예정
    print("정답: \(game.getTargetNumber())")

    
    while true {
        print("\n3자리 숫자를 입력하세요: ", terminator: "")
        guard let input = readLine() else { continue }
        
        let result = game.makeGuess(input)
        
        switch result {
        case .invalidInput:
            print("올바른 3자리 숫자를 입력해주세요. (중복되지 않은 숫자)")
            
        case .ongoing(let strikes, let balls):
            if strikes == 0 && balls == 0 {
                print("아웃!")
            } else {
                print("\(strikes)스트라이크 \(balls)볼")
            }
            
        case .gameWon(let attempts):
            print("축하합니다! \(attempts)번 만에 맞추셨습니다!")
            return attempts
        }
    }
}

// 메인 프로그램 실행
let gameHistory = GameHistory()

while true {
    // 메뉴 표시 및 사용자 입력 받기
    guard let option = showMenu() else {
        print("잘못된 입력입니다. 1-3 사이의 숫자를 입력해주세요.")
        continue
    }
    
    // 선택된 메뉴 실행
    switch option {
    case .startGame:
        // 게임 실행 및 결과 저장
        if let attempts = playGame() {
            gameHistory.addRecord(attempts: attempts)
        }
        
    case .showRecords:
        gameHistory.showRecords()
        
    case .exit:
        print("\n게임을 종료합니다. 안녕히 가세요!")
        exit(0)
    }
}
