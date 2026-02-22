//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Radu Edward-Andrei on 21.02.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    
    private let totalRounds = 8
    @State private var round = 1
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    .foregroundStyle(.primary)
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(name: countries[number])
                        }
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score \(userScore)")
                    .foregroundStyle(.white)
                    .font(.largeTitle.weight(.bold))
                
                Spacer()
            }
            .padding()
        }
        .alert("\(scoreTitle)", isPresented: $showingScore) {
            if round == totalRounds {
                Button("Play again", action: reset)
            } else {
                Button("Continue", action: askQuestion)
            }
            
        } message: {
            if round == totalRounds {
                Text("Your final score is \(userScore)")
            } else {
                Text("Your score is \(userScore)")
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            scoreTitle = "Wrong, that is the flag of \(countries[number])"
            userScore -= 1
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        round += 1
    }
    
    func reset() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        userScore = 0
        round = 1
    }
}

struct FlagImage: View {
    let name: String
    
    var body: some View {
        Image(name)
            .flagModifiers()
    }
}

struct FlagModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

extension View {
    func flagModifiers() -> some View{
        modifier(FlagModifier())
    }
}

#Preview {
    ContentView()
}
