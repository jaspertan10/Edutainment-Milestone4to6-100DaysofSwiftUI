//
//  ContentView.swift
//  Edutainment
//
//  Created by Jasper Tan on 11/26/24.
//

import SwiftUI

struct multiplicationQuestion {
    var multiplicand: Int
    var multiplier: Int
    
    var answer: Int {
        multiplicand * multiplier
    }
}

struct ContentView: View {
    
    /* Game Settings */
    // Multiplication Ranges
    @State private var multiplicationRangeStart: Int = 2
    private var multiplicationMinRange: ClosedRange<Int> {
        0...multiplicationRangeEnd
    }
    
    @State private var multiplicationRangeEnd: Int = 12
    private var multiplicationMaxRange: ClosedRange<Int> {
        multiplicationRangeStart...15
    }
    
    //Number of question settings
    @State private var numberOfQuestions = 5
    let maxNumOfQuestionsRange = 1...15
    
    
    /* Game variables */
    @State private var currentQuestion: multiplicationQuestion?
    @State private var userAnswer: Int?
    @State private var currentRound = 1
    @State private var userScore = 0
    @State private var gameStarted = false
    
    /* Alerts */
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var endGameAlert = false
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Times Table Settings") {
                        Stepper("# of Questions: \(numberOfQuestions)", value: $numberOfQuestions, in: maxNumOfQuestionsRange)
                            .disabled(gameStarted)
                        
                        Stepper("Min Range: \(multiplicationRangeStart)", value: $multiplicationRangeStart, in: multiplicationMinRange)
                            .disabled(gameStarted)
                        Stepper("Max Range: \(multiplicationRangeEnd)", value: $multiplicationRangeEnd, in: multiplicationMaxRange)
                            .disabled(gameStarted)
                    }
                    
                    if let question = currentQuestion {
                        Section("Game Status") {
                            Text("Current Score: \(userScore)")
                            Text("Round \(currentRound) out of \(numberOfQuestions)")
                        }
                        
                         Section("Question") {
                            HStack {
                                Text("What is \(question.multiplicand) X \(question.multiplier) = ")
                                Spacer()
                                TextField("Answer", value: $userAnswer, format: .number)
                                    .keyboardType(.numberPad)
                                    .onSubmit {
                                        checkAnswer()
                                    }
                            }
                        }
                        
                    }
                }
                
            }
            .navigationTitle("Times Tables")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Start") {
                    gameStart()
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("End") {
                        endCurrentGame()
                    }
                    .foregroundStyle(.red)
                }
            })
            .alert(alertTitle, isPresented: $showAlert) {
                Button("Continue") {
                    nextRound()
                }
            } message: {
                Text(alertMessage)
            }
            .alert(alertTitle, isPresented: $endGameAlert) {
                Button("End Game") {
                    endCurrentGame()
                }
            } message: {
                Text(alertMessage)
            }



        }
    }
    
    func checkAnswer() {
        if let question = currentQuestion {
            if let userAnswer = userAnswer {
                if userAnswer == question.answer {
                    alertTitle = "Correct!"
                    userScore += 1
                }
                else {
                    alertTitle = "Wrong!"
                    
                }
                
                alertMessage = "\(question.multiplicand) X \(question.multiplier) = \(question.answer)"
                showAlert = true
            }
        }
    }
    
    func endCurrentGame() {
        currentQuestion = nil
        userAnswer = nil
        userScore = 0
        currentRound = 1
        gameStarted = false
    }
    
    func gameStart() {
        endCurrentGame()
        
        newQuestion()
        
        gameStarted = true
    }
    
    func nextRound() {
        
        guard(currentRound < numberOfQuestions) else {
            alertTitle = "Game Over!"
            alertMessage = "Final Score: \(userScore) out of \(numberOfQuestions)"
            endGameAlert = true
            return
        }
        
        userAnswer = nil
        
        newQuestion()
        
        currentRound += 1
        
    }
    
    func newQuestion() {
        currentQuestion = multiplicationQuestion(multiplicand: Int.random(in: multiplicationRangeStart...multiplicationRangeEnd), multiplier: Int.random(in: multiplicationRangeStart...multiplicationRangeEnd))
    }
    
}

#Preview {
    ContentView()
}
