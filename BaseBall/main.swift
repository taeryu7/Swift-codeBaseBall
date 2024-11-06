//
//  main.swift
//  BaseBall
//
//  Created by on 11/5/24.
//
import Foundation

// 게임 실행
func playGame() {
    print("숫자야구 게임을 시작합니다!")
    let game = BaseballGame()
    
    while true {
        print("3자리 숫자를 입력하세요: ", terminator: "")
        guard let input = readLine() else { continue }
        
        let result = game.makeGuess(input)
        
        switch result {
        case .invalidInput:
            print("올바른 3자리 숫자를 입력해주세요. (중복되지 않은 숫자)")
        case .ongoing(let strikes, let balls):
            print("\(strikes)스트라이크 \(balls)볼")
        case .gameWon(let attempts):
            print("축하합니다! \(attempts)번 만에 맞추셨습니다!")
            return
        }
    }
}

// 게임 시작
playGame()
