//
//  main.swift
//  BaseBall
//
//  Created by on 11/5/24.
//
/**
 // main.swift 파일
 // 프로젝트 생성시 자동 생성됨

 let game = BaseballGame()
 game.start() // BaseballGame 인스턴스를 만들고 start 함수를 구현하기


 // BaseballGame.swift 파일 생성
 class 혹은 struct {
     func start() {
         let answer = makeAnswer() // 정답을 만드는 함수
     }
     
     func makeAnswer() -> Int {
         // 함수 내부를 구현하기
     }
 }
 */

import Foundation

var randomNumbers: Set<Int> = []    // 숫자 담을 int 배열 세팅
var answerNumbers: [Int] = []       // 정답 저장할 변수(배열) 생성

while randomNumbers.count < 3 {
    let numbers = Int.random(in: 1...9)
    randomNumbers.insert(numbers)
}


answerNumbers = Array(randomNumbers)
print("정답은: \(randomNumbers)") // 정답



