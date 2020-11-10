import Foundation
import Darwin

// Difficulty options
enum Difficulty {
    case easy, hard
}

class Game {
    
    // Properties
    var round:Int = 1
    var roundQuestions:Int = 1
    var questionNumber:Int = 1
    var difficulty:Difficulty?
    var player:Player?
    var eliminatedAnswers:Bool = false
    var eliminatedAnswersBtn:Bool = false
    var audienceAsked:Bool = false
    var friendCalled:Bool = false
    var answerBtn = false
    var bankOfQuestions:BankOfQuestions = BankOfQuestions()
    let possibleAnswers:[String] = ["A", "B", "C", "D"]
    let questionValueEasy:[Int:Double] = [1:100, 2:500, 3:1000, 4:8000, 5:16000, 6:32000, 7:125000, 8:500000, 9:1000000]
    let questionValueHard:[Int:Double] = [1:100, 2:200, 3:300, 4:500, 5:1000, 6:2000, 7:4000, 8:8000, 9:16000, 10:32000, 11:64000, 12:125000, 13:250000, 14:500000, 15:1000000]
    
    // Initializer
    init() {}
    
    // Methods
    // Play the game
    func play() {
        self.welcomeScreen()
        self.createPlayer()
        self.setDifficulty()
        if (self.difficulty == Difficulty.easy) {
            repeat {
                self.bankOfQuestions.randomQuestion()
                repeat {
                    self.questionScreen()
                    self.answerScreen()
                } while (self.answerBtn == false)
                self.answerBtn = false
            } while (self.questionNumber < 10)
        } else {
            repeat {
                self.bankOfQuestions.randomQuestion()
                repeat {
                    self.questionScreen()
                    self.answerScreen()
                } while(self.answerBtn == false)
                self.answerBtn = false
            } while (self.questionNumber < 16)
        }
        self.gameWon()
    }
    
    // Question screen
    func questionScreen() {
        if (self.eliminatedAnswersBtn == false) {
            print("\n=======================QUESTION \(self.questionNumber)======================= \n" +
                "\(self.bankOfQuestions.currentQuestion!.question) \n" +
                "A. \(self.bankOfQuestions.currentQuestion!.options[0]) \n" +
                "B. \(self.bankOfQuestions.currentQuestion!.options[1]) \n" +
                "C. \(self.bankOfQuestions.currentQuestion!.options[2]) \n" +
                "D. \(self.bankOfQuestions.currentQuestion!.options[3]) \n" +
                "======================================================== \n")
                
                print("GAME INFORMATION: \n" +
                    "Round: \(self.round) \n" +
                    "Balance: $ \(self.player!.award) \n")
        } else {
            var answersArray = [0, 1, 2, 3]
            let answer = self.bankOfQuestions.currentQuestion!.answer
            var newAnswers:[Int] = []
            for i in 0...3 {
                if (self.bankOfQuestions.currentQuestion!.options[i] == answer) {
                    newAnswers.append(i)
                    answersArray.remove(at: i)
                    let anotherOption = answersArray.randomElement()
                    newAnswers.append(anotherOption!)
                    newAnswers.sort()
                    break
                }
            }
            print("\n=======================QUESTION \(self.questionNumber)======================= \n" +
                "\(self.bankOfQuestions.currentQuestion!.question)")
            if newAnswers.contains(0) {
                print("A. \(self.bankOfQuestions.currentQuestion!.options[0])")
            }
            if newAnswers.contains(1) {
                print("B. \(self.bankOfQuestions.currentQuestion!.options[1])")
            }
            if newAnswers.contains(2) {
                print("C. \(self.bankOfQuestions.currentQuestion!.options[2])")
            }
            if newAnswers.contains(3) {
                print("D. \(self.bankOfQuestions.currentQuestion!.options[3])")
            }
            print("========================================================\n")
            self.eliminatedAnswersBtn = false
        }
    }
    
    // Lifeline screen
    func lifelineScreen() {
        let callFriend = "2. Call a friend"
        let askAudience = "3. Ask the audience"
        let eliminateAnswers = "4. Eliminate two incorrect answers"
        var lifelineArray:[String] = []
        if (self.friendCalled == false) {
            lifelineArray.append(callFriend)
        }
        if (self.audienceAsked == false) {
            lifelineArray.append(askAudience)
        }
        if (self.eliminatedAnswers == false) {
            lifelineArray.append(eliminateAnswers)
        }
        print("\(player!.name), what do you want to do ?")
        print("1. Answer the question")
        for l in lifelineArray {
            print("\(l)")
        }
    }
    
    // Answer screen
    func answerScreen() {
        if (self.round != 1 && self.difficulty == Difficulty.hard) || (self.difficulty == Difficulty.easy) {
            if (self.friendCalled == false || self.audienceAsked == false || eliminatedAnswers == false) {
                self.lifelineScreen()
                var option:Int?
                repeat {
                    repeat {
                        option = Int(readLine()!)
                        if option == nil {
                            print("Please, choose a valid option!")
                        }
                    } while (option == nil)
                    if (option == 1) {
                        let option:String = self.askAnswer()
                        let isCorrect = bankOfQuestions.checkAnswer(optionChosen: option)
                        if (isCorrect == true) {
                            self.updatePlayerAward()
                            self.proceed()
                        } else {
                            self.gameOver()
                        }
                    } else if (option == 2) {
                        self.callFriend()
                    } else if (option == 3) {
                        self.askAudience()
                    } else if (option == 4) {
                        self.eliminateAnswer()
                    } else {
                        print("Please, choose a valid option")
                    }
                } while (option! < 1 || option! > 4)
            } else {
                let option:String = self.askAnswer()
                let isCorrect = bankOfQuestions.checkAnswer(optionChosen: option)
                if (isCorrect == true) {
                    self.updatePlayerAward()
                    self.proceed()
                } else {
                    self.gameOver()
                }
            }
        } else {
            let option:String = self.askAnswer()
            let isCorrect = bankOfQuestions.checkAnswer(optionChosen: option)
            if (isCorrect == true) {
                self.updatePlayerAward()
                self.proceed()
            } else {
                self.gameOver()
            }
        }
    }
    
    // Game Over
    func gameOver() {
        print("The correct answer is \(self.bankOfQuestions.currentQuestion!.answer). Sorry, you lost.")
        sleep(1)
        print("GAME OVER")
        sleep(1)
        exit(0)
    }
    
    // Update player balance
    func updatePlayerAward() {
        if (self.difficulty == Difficulty.easy) {
            self.player!.award = self.questionValueEasy[self.questionNumber]!
        } else {
            self.player!.award = self.questionValueHard[self.questionNumber]!
        }
    }
    
    // Proceed the game when the answer is correct
    func proceed() {
        if (self.difficulty == Difficulty.easy) {
            if ([3, 6].contains(self.questionNumber)) {
                self.walkAway()
            }
            if (self.round != 4 && self.roundQuestions != 4) {
                self.questionNumber += 1
                if (self.roundQuestions == 3) {
                    self.round += 1
                    self.roundQuestions = 1
                } else {
                    self.roundQuestions += 1
                }
            } else {
                self.gameWon()
            }
        } else {
            if ([5, 11].contains(self.questionNumber)) {
                self.walkAway()
            }
            if (self.round != 4 && self.roundQuestions != 6) {
                self.questionNumber += 1
                if (self.roundQuestions == 5) {
                    self.round += 1
                    self.roundQuestions = 1
                } else {
                    self.roundQuestions += 1
                }
            } else {
                self.gameWon()
            }
        }
    }
    
    // Winner message
    func gameWon() {
        print("CONGRATULATIONS! YOU WON $ 1,000,000!")
        sleep(1)
        exit(0)
    }
    
    // Ask for the answer
    func askAnswer() -> String {
        var isFinal:String
        var option:String
        repeat {
            repeat {
                print("\(player!.name), what is your answer?")
                option = readLine()!
            } while !(self.possibleAnswers.contains(option.uppercased()))
            print("So, letter \(option.uppercased()) is your final answer ? (y/n)")
            isFinal = readLine()!
        } while (isFinal == "n")
        self.answerBtn = true
        return option
    }
    
    // Call a friend
    func callFriend() {
        let friendName:String
        print("Who are you going to call?")
        friendName = readLine()!
        print("Calling \(friendName)...")
        sleep(2)
        print(" ...")
        sleep(2)
        print(" ...")
        sleep(2)
        print(" ...")
        sleep(1)
        let answered = Int.random(in:1...2)
        if (answered == 1) {
            print("Hello, \(self.player!.name)! It's \(friendName) I think the answer is \(self.bankOfQuestions.currentQuestion!.answer)!")
            sleep(2)
        } else {
            print("Sorry, nobody is answering!")
            sleep(2)
        }
        self.friendCalled = true
    }
    
    // Ask audience
    func askAudience() {
        let repeatedAnswer = bankOfQuestions.currentQuestion!.answer.uppercased()
        print("THE AUDIENCE IS SCREAMING:")
        for _ in 1...3 {
            sleep(2)
            print(repeatedAnswer + " !!!!!")
            sleep(1)
        }
        self.audienceAsked = true
    }
    
    // Eliminate answers
    func eliminateAnswer() {
        print("NOW YOU HAVE 50% TO GET THE CORRECT ANSWER!")
        sleep(1)
        self.eliminatedAnswers = true
        self.eliminatedAnswersBtn = true
    }
    
    // Select difficulty
    func setDifficulty() {
        var difficultyNumber:Int?
        repeat {
            self.difficultyScreen()
            repeat {
                difficultyNumber = Int(readLine()!)
                if difficultyNumber == nil {
                    print("Please, choose a valid option!")
                }
            } while (difficultyNumber == nil)
        } while (difficultyNumber! < 1 || difficultyNumber! > 3)
        if (difficultyNumber == 1) {
            self.difficulty = Difficulty.easy
        } else if (difficultyNumber == 2) {
            self.difficulty = Difficulty.hard
        } else if (difficultyNumber == 3) {
            self.exitGame()
        } else {
            print("Please \(self.player!.name), select one of the options below:\n" +
                "1. Easy\n" +
                "2. Hard\n" +
                "3. Exit")
        }
    }
    
    // Difficulty screen
    func difficultyScreen() {
        print("Hello \(self.player!.name), please choose a difficulty option:\n" +
            "1. Easy\n" +
            "2. Hard\n" +
            "3. Exit")
    }

    // Welcome screen
    func welcomeScreen() {
        print("================WELCOME TO================\n" +
              "=======WHO WANTS TO BE A MILLIONARE=======\n" +
              "==========================================\n" +
              "What is your name?")
    }
    
    // Create a player
    func createPlayer() {
        let name:String = readLine()!
        self.player = Player(name:name)
    }
    
    // Walk away
    func walkAway() {
        print("\nCongratulations, \(self.player!.name). You can choose one of the options below: \n" +
        "1. Continue the game \n" +
        "2. Walk away")
        var option:Int
        repeat {
            option = Int(readLine()!)!
            if (option == 2) {
                print("YOU WON $\(self.player!.award)")
                sleep(1)
                exit(0)
            } else if (option != 1) {
                print("Please, choose a valid option")
            } else if (option == 1) {
                print("\(player!.name), let's go to the next round!")
                sleep(1)
            }
        } while (!([1, 2].contains(option)))
    }
    
    // Exit the game
    func exitGame() {
        print("SEE YOU!")
        exit(0)
    }
}

