import Foundation


class BankOfQuestions {
    
    // Properties
    var questionNumber:Int = 1
    var currentQuestion:Question?
    var chosenQuestions:[Int] = []
    let questions:[Int:Question] = [
        1:Question(question:"How many seconds are in a minute?",
                     options:["30" , "1", "60", "300"],
                     answer:"60"),
        2:Question(question:"What makeup product makes eyelashes appear longer?",
                     options:["Mascara", "Blush", "Lipstick", "Foundation"],
                     answer: "Mascara"),
        3:Question(question:"What city contains the Eiffel Tower?",
                     options:["Sydney", "New York City", "Los Angeles", "Paris"],
                     answer: "Paris"),
        4:Question(question:"Which sport is also known as football?",
                     options:["Soccer", "Basketball", "Baseball", "Cricket"],
                     answer: "Soccer"),
        5:Question(question:"How many continents are there?",
                     options:["1", "3", "7", "20"],
                     answer: "7"),
        6:Question(question:"Who wasn't a member of the Beatles?",
                     options:["John Lennon", "Paul McCartney", "Ringo Star", "Justin Timberlake"],
                     answer: "Justin Timberlake"),
        7:Question(question:"Which of the following is not a type of pasta?",
                     options:["Spaghetti", "Escargot", "Fettuccine", "Ziti"],
                     answer: "Escargot"),
        8:Question(question:"Which state has cities named San Francisco and Hollywood?",
                     options:["California", "Utah", "Hawaii", "Montana"],
                     answer: "California"),
        9:Question(question:"Which instrument does not have strings?",
                     options:["Guitar", "Trombone", "Bass", "Cello"],
                     answer: "Trombone"),
        10:Question(question:"What product does Tesla produce?",
                     options:["Ice cream", "Hair brushes", "Televisions", "Electric cars"],
                     answer: "Electric cars"),
        11:Question(question:"Which animal is not a primate?",
                     options:["Chimpanzee", "Dolphin", "Gorillla", "Orangutan"],
                     answer: "Dolphin"),
        12:Question(question:"What gas makes voices sound higher when inhaled?",
                     options:["Oxygen", "Nitrogen", "Sulfur Hexafluoride", "Helium"],
                     answer: "Helium"),
        13:Question(question:"What American holiday falls on July 4?",
                     options:["Thanksgiving Day", "Independence Day", "Christmas Day", "New Year's Day"],
                     answer: "Independence Day"),
        14:Question(question:"Which candy bar shares its name with a galaxy?",
                     options:["Snickers", "Milky Way", "3 Musketeers", "Almond Joy"],
                     answer: "Milky Way"),
        15:Question(question:"What is the capital of England?",
                     options:["London", "Washington D.C.", "Rome", "Moscow"],
                     answer: "London")
    ]
    
    // Initializer
    init() {}
    
    // Methods
    // Choose a random question
    func randomQuestion() {
        var alreadyChosen:Bool = true
        repeat {
            let number = Int.random(in:1...15)
            if !(self.chosenQuestions.contains(number)) {
                alreadyChosen = false
                self.chosenQuestions.append(number)
                let question:Question = self.questions[number]!
                self.currentQuestion = question
            }
        } while(alreadyChosen == true)
    }
    
    // Check the answer
    func checkAnswer(optionChosen:String) -> Bool {
        let letterChosen = optionChosen.uppercased()
        let correctAnswer = self.currentQuestion!.answer
        let correctLetter:String
        if (correctAnswer == currentQuestion!.options[0]) {
            correctLetter = "A"
        } else if (correctAnswer == currentQuestion!.options[1]) {
            correctLetter = "B"
        } else if (correctAnswer == currentQuestion!.options[2]) {
            correctLetter = "C"
        } else {
            correctLetter = "D"
        }
        var isCorrect:Bool = false
        if (letterChosen == correctLetter) {
            print("THE ANSWER IS CORRECT!")
            sleep(1)
            isCorrect = true
        }
        return isCorrect
    }
    
    
}


