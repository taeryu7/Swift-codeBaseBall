import Foundation

/// 게임 기록을 저장하는 구조체
struct GameRecord {
    let date: Date
    let attempts: Int
    let answer: String  // 정답 숫자 추가
}

/// 게임의 전체 기록을 관리하는 클래스
class GameHistory {
    private var records: [GameRecord] = []
    
    /// 새로운 게임 기록 추가
    func addRecord(attempts: Int, answer: String) {
        records.append(GameRecord(date: Date(), attempts: attempts, answer: answer))
    }
    
    /// 모든 게임 기록 조회
    func showRecords() {
        if records.isEmpty {
            print("\n아직 게임 기록이 없습니다.")
            return
        }
        
        print("\n[ 게임 기록 ]")
        print("게임번호\t날짜\t\t\t정답\t시도 횟수\t평가")
        print("----------------------------------------------------------------")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // 각 게임의 기록을 출력
        for (index, record) in records.enumerated() {
            let evaluation = evaluatePerformance(attempts: record.attempts)
            print("#\(index + 1)\t\(dateFormatter.string(from: record.date))\t\(record.answer)\t\(record.attempts)회\t\(evaluation)")
        }
        
        // 통계 정보 출력
        printStatistics()
    }
    
    /// 게임 성적 평가
    private func evaluatePerformance(attempts: Int) -> String {
        switch attempts {
        case 1...3: return "대단한 실력이네요! 🎉"
        case 4...6: return "잘 했어요! 😊"
        case 7...9: return "괜찮아요 👍"
        default: return "다음에는 더 잘할 수 있어요 💪"
        }
    }
    
    /// 통계 정보 출력
    private func printStatistics() {
        guard !records.isEmpty else { return }
        
        let totalGames = records.count
        let totalAttempts = records.reduce(0) { $0 + $1.attempts }
        let averageAttempts = Double(totalAttempts) / Double(totalGames)
        
        let bestGame = records.min(by: { $0.attempts < $1.attempts })!
        let worstGame = records.max(by: { $0.attempts < $1.attempts })!
        
        print("\n[ 통계 정보 ]")
        print("----------------------------------------------------------------")
        print("총 게임 수: \(totalGames)게임")
        print("평균 시도 횟수: \(String(format: "%.1f", averageAttempts))회")
        print("최고 기록: \(bestGame.attempts)회")
        print("최저 기록: \(worstGame.attempts)회")
        print("----------------------------------------------------------------\n")
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
func playGame() -> (attempts: Int, answer: String)? {
    print("\n게임을 시작합니다!")
    print("서로 다른 3자리 숫자를 맞혀보세요.")
    print("각 숫자는 0과 9 사이이며, 첫 번째 자리는 0이 될 수 없습니다.")
    
    let game = BaseballGame()
    let answer = game.getTargetNumber()  // 정답 저장
    
    // 테스트/디버깅용 정답 출력
    print("정답: \(answer)")
    
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
            print("축하합니다! \(attempts)번 만에 맞추셨습니다.")
            return (attempts, answer)
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
        if let result = playGame() {
            gameHistory.addRecord(attempts: result.attempts, answer: result.answer)
        }
        
    case .showRecords:
        gameHistory.showRecords()
        
    case .exit:
        print("\n게임을 종료합니다.")
        exit(0)
    }
}

