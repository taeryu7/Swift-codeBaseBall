import Foundation

class BaseballGame {
    private var targetNumber: [Int]
    private var attempts: Int
    
    init() {
        self.targetNumber = BaseballGame.generateRandomNumber()
        self.attempts = 0
    }
    
    // 랜덤 3자리 숫자 생성 - 개선된 버전
    private static func generateRandomNumber() -> [Int] {
        // 1-9까지의 숫자로 배열 생성 (첫 자리는 0이 올 수 없으므로)
        var availableNumbers = Array(1...9)
        // 첫 번째 숫자 선택 및 제거
        let firstIndex = Int.random(in: 0..<availableNumbers.count)
        let firstNumber = availableNumbers.remove(at: firstIndex)
        
        // 두 번째, 세 번째 숫자를 위해 0 추가
        availableNumbers.append(0)
        
        // 두 번째 숫자 선택 및 제거
        let secondIndex = Int.random(in: 0..<availableNumbers.count)
        let secondNumber = availableNumbers.remove(at: secondIndex)
        
        // 세 번째 숫자 선택
        let thirdIndex = Int.random(in: 0..<availableNumbers.count)
        let thirdNumber = availableNumbers[thirdIndex]
        
        return [firstNumber, secondNumber, thirdNumber]
    }
    
    // 사용자 입력값 검증
    private func validateInput(_ input: String) -> [Int]? {
        guard input.count == 3,
              let number = Int(input),
              number >= 100 && number <= 999 else {
            return nil
        }
        
        let digits = input.map { Int(String($0))! }
        
        // 중복된 숫자가 있는지 확인
        guard Set(digits).count == 3 else {
            return nil
        }
        
        return digits
    }
    
    // 스트라이크와 볼 계산
    private func checkNumbers(guess: [Int]) -> (strikes: Int, balls: Int) {
        var strikes = 0
        var balls = 0
        
        for i in 0..<3 {
            if guess[i] == targetNumber[i] {
                strikes += 1
            } else if targetNumber.contains(guess[i]) {
                balls += 1
            }
        }
        
        return (strikes, balls)
    }
    
    // 게임 진행을 위한 메서드
    func makeGuess(_ inputNumber: String) -> GameResult {
        guard let guess = validateInput(inputNumber) else {
            return .invalidInput
        }
        
        attempts += 1
        let result = checkNumbers(guess: guess)
        
        if result.strikes == 3 {
            return .gameWon(attempts: attempts)
        }
        
        return .ongoing(strikes: result.strikes, balls: result.balls)
    }
    
    // 디버깅을 위한 정답 확인 메서드 (필요시 사용)
    func getTargetNumber() -> String {
        return targetNumber.map(String.init).joined()
    }
    
    // 게임 결과를 나타내는 열거형
    enum GameResult {
        case invalidInput
        case ongoing(strikes: Int, balls: Int)
        case gameWon(attempts: Int)
    }
}

