import Foundation

class BaseballGame {
    private var targetNumber: [Int]
    private var attempts: Int
    
    init() {
        self.targetNumber = BaseballGame.generateRandomNumber()
        self.attempts = 0
    }
    
    // 랜덤 3자리 숫자 생성
    private static func generateRandomNumber() -> [Int] {
        var numbers = Array(0...9)
        var result: [Int] = []
        
        // 첫 번째 숫자는 0이 아닌 숫자여야 함
        let firstNum = Int.random(in: 1...9)
        result.append(firstNum)
        numbers.remove(at: firstNum)
        
        // 나머지 두 숫자 선택
        for _ in 0..<2 {
            let index = Int.random(in: 0..<numbers.count)
            result.append(numbers[index])
            numbers.remove(at: index)
        }
        
        return result
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
    
    // 게임 결과를 나타내는 열거형
    enum GameResult {
        case invalidInput
        case ongoing(strikes: Int, balls: Int)
        case gameWon(attempts: Int)
    }
}
