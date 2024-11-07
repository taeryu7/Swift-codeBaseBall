//
//  BaseballGame.swift
//  BaseBall
//
//  Created by 유태호 on 11/5/24.
//

// BaseballGame.swift

import Foundation

// 숫자야구 게임의 핵심 로직을 담당하는 클래스
class BaseballGame {
    // MARK: - Properties
    
    /// 컴퓨터가 생성한 정답 숫자 배열 (3자리)
    private var targetNumber: [Int]
    
    /// 사용자가 시도한 횟수
    private var attempts: Int
    
    // MARK: - Initialization
    
    /// BaseballGame 인스턴스를 초기화하고 랜덤한 타겟 넘버를 생성
    init() {
        self.targetNumber = BaseballGame.generateRandomNumber()
        self.attempts = 0
    }
    
    // MARK: - Private Methods
    
    // 중복되지 않는 3자리의 랜덤 숫자를 생성하는 메소드
    // - Returns: 3개의 정수로 이루어진 배열. 첫 번째 숫자는 1-9, 나머지는 0-9 범위
    private static func generateRandomNumber() -> [Int] {
        // 1-9까지의 숫자로 배열 생성 (첫 자리는 0이 올 수 없으므로)
        var availableNumbers = Array(1...9)
        
        // 첫 번째 숫자 선택 및 제거 (1-9 중 하나)
        let firstIndex = Int.random(in: 0..<availableNumbers.count)
        let firstNumber = availableNumbers.remove(at: firstIndex)
        
        // 두 번째, 세 번째 숫자를 위해 0 추가
        availableNumbers.append(0)
        
        // 두 번째 숫자 선택 및 제거 (0-9 중 하나, 첫 번째 숫자 제외)
        let secondIndex = Int.random(in: 0..<availableNumbers.count)
        let secondNumber = availableNumbers.remove(at: secondIndex)
        
        // 세 번째 숫자 선택 (0-9 중 하나, 첫 번째, 두 번째 숫자 제외)
        let thirdIndex = Int.random(in: 0..<availableNumbers.count)
        let thirdNumber = availableNumbers[thirdIndex]
        
        return [firstNumber, secondNumber, thirdNumber]
    }
    
    // 사용자 입력값의 유효성을 검사하는 메소드
    // - Parameter input: 사용자가 입력한 문자열
    // - Returns: 유효한 경우 3자리 숫자 배열, 유효하지 않은 경우 nil
    private func validateInput(_ input: String) -> [Int]? {
        // 입력값이 3자리 숫자인지 확인
        guard input.count == 3,
              let number = Int(input),    // 숫자로 변환 가능한지 확인
              number >= 100 && number <= 999 else {  // 3자리 숫자 범위인지 확인
            return nil
        }
        
        // 문자열을 숫자 배열로 변환
        let digits = input.map { Int(String($0))! }
        
        // 중복된 숫자가 있는지 확인
        guard Set(digits).count == 3 else {
            return nil
        }
        
        return digits
    }
    
    /// 추측한 숫자와 정답을 비교하여 스트라이크와 볼을 계산하는 메소드
    /// - Parameter guess: 사용자가 추측한 3자리 숫자 배열
    /// - Returns: (스트라이크 개수, 볼 개수) 튜플
    private func checkNumbers(guess: [Int]) -> (strikes: Int, balls: Int) {
        var strikes = 0
        var balls = 0
        
        // 각 자리수별로 비교
        for i in 0..<3 {
            if guess[i] == targetNumber[i] {
                // 같은 자리에 같은 숫자가 있으면 스트라이크
                strikes += 1
            } else if targetNumber.contains(guess[i]) {
                // 다른 자리에 같은 숫자가 있으면 볼
                balls += 1
            }
        }
        
        return (strikes, balls)
    }
    
    // MARK: - Public Methods
    
    /// 사용자의 추측을 처리하고 게임 결과를 반환하는 메소드
    /// - Parameter inputNumber: 사용자가 입력한 3자리 숫자 문자열
    /// - Returns: 게임 결과 (GameResult 열거형)
    func makeGuess(_ inputNumber: String) -> GameResult {
        // 입력값 유효성 검사
        guard let guess = validateInput(inputNumber) else {
            return .invalidInput
        }
        
        // 시도 횟수 증가
        attempts += 1
        
        // 스트라이크와 볼 계산
        let result = checkNumbers(guess: guess)
        
        // 승리 조건 (3 스트라이크) 확인
        if result.strikes == 3 {
            return .gameWon(attempts: attempts)
        }
        
        // 게임 진행 중
        return .ongoing(strikes: result.strikes, balls: result.balls)
    }
    
    /// 디버깅을 위한 정답 확인 메소드
    /// - Returns: 정답 숫자를 문자열로 반환
    func getTargetNumber() -> String {
        return targetNumber.map(String.init).joined()
    }
    
    // MARK: - Nested Types
    
    // 게임의 진행 상태를 나타내는 열거형
    enum GameResult {
        /// 잘못된 입력 (3자리가 아니거나 중복된 숫자가 있는 경우)
        case invalidInput
        /// 게임 진행 중 (스트라이크와 볼 개수 포함)
        case ongoing(strikes: Int, balls: Int)
        /// 게임 승리 (시도 횟수 포함)
        case gameWon(attempts: Int)
    }
}

