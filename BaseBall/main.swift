//
//  main.swift
//  BaseBall
//
//  Created by on 11/5/24.
//

import Foundation

var randomNumbers: Set<Int> = []    // 숫자 담을 int 배열 세팅
var answerNumbers: [Int] = []       // 정답 저장할 변수(배열) 생성

while randomNumbers.count < 3 {
    let numbers = Int.random(in: 1...9)
    randomNumbers.insert(numbers)
}


answerNumbers = Array(randomNumbers)
print("정답은: \(randomNumbers)") // 정답



