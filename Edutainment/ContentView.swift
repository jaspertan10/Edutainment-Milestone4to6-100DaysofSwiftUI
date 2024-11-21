//
//  ContentView.swift
//  Edutainment
//
//  Created by Jasper Tan on 11/18/24.
//

import SwiftUI

struct MultiplicationQuestion: Identifiable {
    
    let id: UUID = UUID()
    
    var num1: Int
    var num2: Int
    var answer: Int
}

struct ContentView: View {
    
    /* Grid */
    let columns = [
       GridItem(.flexible()),
       GridItem(.flexible()),
       GridItem(.flexible()),
       GridItem(.flexible()),
       GridItem(.flexible())
    ]
    
    @State private var buttonStates = Array(repeating: false, count: 10)
    
    @State private var numberOfQuestions = 3
    
    private var gameReadyToStart: Bool {
        numberOfActivatedButtons == 2
    }
    
    @State private var listOfQuestions : [MultiplicationQuestion] = []
    @State private var userAnswers: [Int?] = []
    private var numberOfActivatedButtons: Int {
        
        //Below code is equivalent to:
        // let activatedButtons = buttonStates.filter { $0 }
        let activatedButtons = buttonStates.filter { index in
            index // i.e. index == true
        }
        
        return activatedButtons.count
    }
    private var multiplicands: [Int]? {
        
        var tempArr: [Int] = []
        
        /* Ensure there are 2 activated buttons */
        guard (numberOfActivatedButtons == 2) else {
            return nil
        }

        
        for (index, element) in buttonStates.enumerated() {
            if (element == true) {
                tempArr.append(index)
            }
        }
        
        return [tempArr[0] + 1, tempArr[1] + 1]
    }
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                Text("Select Times Table")
                LazyVGrid(columns: columns) {
                    ForEach(0..<10) { index in
                        Button {
                            changeButtonState(index)
                        } label: {
                            Text("\(index + 1)")
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.white)
                                .background(buttonStates[index] ? Color.gray : Color.blue)
                        }
                        
                    }
                }
                
                Stepper("# of questions: \(numberOfQuestions)", value: $numberOfQuestions, in: 3...10)
                
                Button {
                    if gameReadyToStart {
                        generateTimesTables()
                    }
                } label: {
                    Text("Start")
                        .frame(width: 100, height: 50)
                        .foregroundStyle(.white)
                        .background(gameReadyToStart ? .blue : .gray)
                }
                
                Form {
                    if !listOfQuestions.isEmpty {
                        Section ("Times Table") {
                            ForEach(0..<numberOfQuestions, id: \.self) { questionIndex in
                                HStack {
                                    Text("\(listOfQuestions[questionIndex].num1) X \(listOfQuestions[questionIndex].num2) = ")
                                    
                                    
                                    TextField("Answer", value: $userAnswers[questionIndex], format: .number)
                                }
                            }
                        }
                    }
                }

                
//                Form {
//                    if !listOfQuestions.isEmpty && currentQuestionIndex < listOfQuestions.count && gameReadyToStart {
//                        Section ("Current Question") {
//                            HStack() {
//                                Text("What is \(listOfQuestions[currentQuestionIndex].num1) X \(listOfQuestions[currentQuestionIndex].num2)")
//                                Spacer()
//                                TextField("Your Answer", value: $userAnswerHistory[currentQuestionIndex].userAnswer, format: .number)
//                                    .keyboardType(.numberPad)
//                                    .onSubmit {
//                                        //closure
//                                    }
//                            }
//                        }
//                    }
//                }

                

            }
            .navigationTitle("Edutainment")
            .navigationBarTitleDisplayMode(.inline)
//            .toolbarBackground(Color.blue.gradient, for: .navigationBar)
//            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        }
        //.preferredColorScheme(.dark)
    }
    
    func changeButtonState(_ index: Int) {
        
        if (numberOfActivatedButtons < 2) {
            buttonStates[index].toggle()
        }
        else if (buttonStates[index] == true && numberOfActivatedButtons == 2) {
            buttonStates[index].toggle()
        }
    }
    
    func generateTimesTables() {
        
        if let multiplicands = multiplicands {
            for _ in 0..<numberOfQuestions {
                let num1 = Int.random(in: multiplicands[0]...multiplicands[1])
                let num2 = Int.random(in: multiplicands[0]...multiplicands[1])
                let answer = num1 * num2
                
                listOfQuestions.append(MultiplicationQuestion(num1: num1, num2: num2, answer: answer))
            }
            userAnswers = Array(repeating: nil, count: numberOfQuestions)
        }
    }
    
}

#Preview {
    ContentView()
}
