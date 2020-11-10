import Foundation

class Question {
    
    // Properties
    let question:String
    let options:[String]
    let answer:String
    
    // Initializer
    init(question:String, options:[String], answer:String) {
        self.question = question
        self.options = options
        self.answer = answer
    }
}




