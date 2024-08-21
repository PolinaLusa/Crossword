//
//  ContentView.swift
//  Crossword
//
//  Created by Полина Лущевская on 27.06.24.
//

import SwiftUI

struct ContentView: View {
    let crosswordData: [CrosswordItem] = [
        CrosswordItem(question: "Оранжевый цитрус", answer: "АПЕЛЬСИН"),
        CrosswordItem(question: "Самый крупный цитрус", answer: "ПОМЕЛО"),
        CrosswordItem(question: "Гибрид помело и грейпфрута", answer: "СВИТИ"),
        CrosswordItem(question: "Красная ягода с косточкой", answer: "ВИШНЯ"),
        CrosswordItem(question: "Коричневый плод с зелёной мякотью", answer: "КИВИ"),
        CrosswordItem(question: "Гибрид апельсина и помело", answer: "ГРЕЙПФРУТ")
    ]
    
    struct CrosswordCell {
        var questionNumber: Int?
        var textField: String
    }
    
    @State private var crosswordCells: [[CrosswordCell]] = []
    @State private var resultMessage: String = ""

    private func initializeCrosswordCells() {
        var cells: [[CrosswordCell]] = []
        
        for i in 0..<crosswordData.count {
            let word = crosswordData[i].answer
            var row: [CrosswordCell] = []
            
            for j in 0..<word.count {
                row.append(CrosswordCell(questionNumber: j == 0 ? i + 1 : nil, textField: ""))
            }
            cells.append(row)
        }
        self.crosswordCells = cells
    }

    private func checkAnswers() -> Bool {
        for i in 0..<crosswordData.count {
            let word = crosswordData[i].answer
            for j in 0..<word.count {
                let cell = crosswordCells[i][j]
                let answerChar = String(word[word.index(word.startIndex, offsetBy: j)])
                if cell.textField.uppercased() != answerChar {
                    return false
                }
            }
        }
        return true
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(crosswordCells.indices, id: \.self) { i in
                HStack(spacing: 0) {
                    ForEach(self.crosswordCells[i].indices, id: \.self) { j in
                        TextField("", text: self.$crosswordCells[i][j].textField)
                            .textFieldStyle(PlainTextFieldStyle())
                            .frame(width: 30, height: 30)
                            .multilineTextAlignment(.center)
                            .padding(0)
                            .fixedSize()
                            .border(j == 3 ? Color.purple : Color.gray)
                            .overlay(
                                self.crosswordCells[i][j].questionNumber != nil ?
                                Text("\(self.crosswordCells[i][j].questionNumber!)")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .offset(x: -8, y: -8)
                                : nil
                            )
                            .onChange(of: self.crosswordCells[i][j].textField) { newValue in
                                
                                if newValue.count > 1 {
                                    self.crosswordCells[i][j].textField = String(newValue.prefix(1))
                                }
                            }
                    }
                }
            }

            VStack(alignment: .leading, spacing: 10){
                ForEach(crosswordData.indices, id: \.self) { index in
                    Text("\(index + 1). \(crosswordData[index].question)")
                        .padding(.horizontal)
                        .font(.system(size: 12))
                }
            }
            
            Button(action: {
                if self.checkAnswers() {
                    self.resultMessage = "Кроссворд заполнен правильно!"
                } else {
                    self.resultMessage = "В кроссворде ошибки, проверьте и попробуйте снова"
                }
            }) {
                Text("Проверить ответы")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            
            Text(resultMessage)
                .padding(.top, 10)
                .foregroundColor(resultMessage == "Кроссворд заполнен правильно!" ? .green : .red)
        }
        .onAppear {
            self.initializeCrosswordCells()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
