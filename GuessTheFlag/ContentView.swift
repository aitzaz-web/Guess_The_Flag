//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Aitzaz Munir on 24/06/2024.
//

import SwiftUI


struct TitleModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.blue)
        
    }
    
}
extension View {
    func titleStyle() -> some View {
        modifier(TitleModifier())
    }
}



struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var questionsDone = 0
    @State private var showingFinalScore = false
    @State private var angle: Double = 0
    @State private var selectedFlag: Int? = nil
    


    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
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
                            .foregroundStyle(.secondary)
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                           
                                
                            
                        } label: {
                            FlagImage(countryName: countries[number])
                        }
                        .rotation3DEffect(
                                Angle(degrees: number == correctAnswer ? angle : 0),   // Apply rotation only to the correct flag
                                axis: (x: 0, y: 1, z: 0),  // Rotation around the Y-axis
                                perspective: 0.5  // Perspective for 3D effect
                                            )
                        
                        .opacity(selectedFlag == nil ? 1 : (number == correctAnswer ? 1 : 0.25))
                        
                        
                    }
                    
                }
                
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(userScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }
            
            .padding()
        
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is \(userScore)")
            }
            
            
            .alert("Your Final Score is \(userScore)", isPresented: $showingFinalScore) {
                Button("Restart", action: restartGame)
            }
        }
        .titleStyle()
        
    }
        
        
    
    struct FlagImage: View {
        var countryName : String
        
        

        var body: some View {
            Image(countryName)
                .clipShape(.capsule)
                .shadow(radius: 5)
        }
    }
    
    

    

    func flagTapped(_ number: Int) {
        
        selectedFlag = number
        
        questionsDone = questionsDone + 1
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore = userScore + 1
            withAnimation{angle += 360}
        } else {
            scoreTitle = "Wrong, that is the flag of \(countries[correctAnswer])"
            if userScore > 0{
                userScore = userScore - 1
            }
        }
        
        
        
        showingScore = true
        
        
        
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        if questionsDone == 3 {
            showingFinalScore = true
        }
        selectedFlag = nil
        
    }
    func restartGame() {
        userScore = 0
        questionsDone = 2
    }
}

#Preview {
    ContentView()
}
