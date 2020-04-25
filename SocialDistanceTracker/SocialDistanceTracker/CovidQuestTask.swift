//
//  CovidQuestTask.swift
//  SocialDistanceTracker
//
//  Created by Ayyalu  Jeyaprakash, Balaji (Cognizant) on 25/04/20.
//  Copyright © 2020 Ayyalu  Jeyaprakash, Balaji (Cognizant). All rights reserved.
//

import Foundation
import ResearchKit
public var CovidQuestTask: ORKOrderedTask {
    
     var steps = [ORKStep] ()
    
     let instructionStep = ORKInstructionStep(identifier: "IntroStep")
     instructionStep.title = "COVID-19 self-assessment"
     instructionStep.text = "Take this self-assessment if you think you were exposed to COVID-19 (novel coronavirus) or have symptoms. You’ll get information on what to do next. \r\n\nYou can also take it on behalf of someone else. \r\n\nThis information is not intended to provide medical advice. If you have medical questions, consult a health practitioner or your local public health unit."
     
     steps += [instructionStep]
    
    let answerChoiceall = "severe difficulty breathing(struggling for each breath, can only speak in single words)"
    let answerChoicemost = "severe chest pain(constant tightness or crushing sensation)"
    let answerChoicegoodbit = "feeling confused(for example, unsure of where you are)"
    let answerChoicesome = "losing consciousness"
    
    
    
    let firstchoices: [ORKTextChoice] = [ORKTextChoice(text: answerChoiceall, value: answerChoiceall as NSCoding & NSCopying & NSObjectProtocol),
                                    ORKTextChoice(text: answerChoicemost, value: answerChoicemost as NSCoding & NSCopying & NSObjectProtocol),
                                    ORKTextChoice(text: answerChoicegoodbit, value: answerChoicegoodbit as NSCoding & NSCopying & NSObjectProtocol),
                                    ORKTextChoice(text: answerChoicesome, value: answerChoicesome as NSCoding & NSCopying & NSObjectProtocol)]
    
    let firstAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: ORKChoiceAnswerStyle.singleChoice, textChoices: firstchoices)
    let firstQuestion = "Are you experiencing any of the following symptoms?"

    
     let firstQuestionStep = ORKQuestionStep.init(identifier: "TextChoiceQuestionStepone", title: "COVID-19", question: firstQuestion, answer: firstAnswerFormat)
    firstQuestionStep.isOptional = false
       steps += [firstQuestionStep]
    
    
    let scondans1 = "fever(feeling hot to the touch, a temperature of 37.8 degrees Celsius or higher)"
    let scondans2 = "chills"
    let scondans3 = "cough that's new or worsening(continuous, more than usual)"
    let scondans4 = "barking cough, making a squeaky or whistling noise when breathing(croup)"
    let scondans5 = "shortness of breath(out of breath, unable to breathe deeply)"
    let scondans6 = "sore throat"
    let scondans7 = "difficulty swallowing"
    let scondans8 = "hoarse voice(more rough or harsh than normal)"
    let scondans9 = "runny nose"
    let scondans10 = "stuffy or congested nose"
    let scondans11 = "lost sense of taste or smell"
    let scondans12 = "headache"
    let scondans13 = "digestive issues(nausea/vomiting, diarrhea, stomach pain)"
     let scondans14 = "fatigue(lack of energy, extreme tiredness)"
     let scondans15 = "falling down more than usual"
     let scondans16 = "for young children and infants: sluggishness or lack of appetite"
     let scondans17 = "none of the above"
    
    
    let secondchoices: [ORKTextChoice] = [ORKTextChoice(text: scondans1, value: scondans1 as NSCoding & NSCopying & NSObjectProtocol),
                                       ORKTextChoice(text: scondans2, value: scondans2 as NSCoding & NSCopying & NSObjectProtocol),
                                       ORKTextChoice(text: scondans3, value: scondans3 as NSCoding & NSCopying & NSObjectProtocol),
                                       ORKTextChoice(text: scondans4, value: scondans4 as NSCoding & NSCopying & NSObjectProtocol),
                                       ORKTextChoice(text: scondans5, value: scondans5 as NSCoding & NSCopying & NSObjectProtocol),
                                       ORKTextChoice(text: scondans6, value: scondans6 as NSCoding & NSCopying & NSObjectProtocol),
                                       ORKTextChoice(text: scondans7, value: scondans7 as NSCoding & NSCopying & NSObjectProtocol),
                                       ORKTextChoice(text: scondans8, value: scondans8 as NSCoding & NSCopying & NSObjectProtocol),
                                       ORKTextChoice(text: scondans9, value: scondans9 as NSCoding & NSCopying & NSObjectProtocol),
                                       ORKTextChoice(text: scondans10, value: scondans10 as NSCoding & NSCopying & NSObjectProtocol),
                                       ORKTextChoice(text: scondans11, value: scondans11 as NSCoding & NSCopying & NSObjectProtocol),
                                       ORKTextChoice(text: scondans12, value: scondans12 as NSCoding & NSCopying & NSObjectProtocol),
                                       ORKTextChoice(text: scondans13, value: scondans13 as NSCoding & NSCopying & NSObjectProtocol),
                                       ORKTextChoice(text: scondans14, value: scondans14 as NSCoding & NSCopying & NSObjectProtocol),
                                       ORKTextChoice(text: scondans15, value: scondans15 as NSCoding & NSCopying & NSObjectProtocol),
                                       ORKTextChoice(text: scondans16, value: scondans16 as NSCoding & NSCopying & NSObjectProtocol),
                                       ORKTextChoice(text: scondans17, value: scondans17 as NSCoding & NSCopying & NSObjectProtocol)
                                      ]
    
    let secondAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: ORKChoiceAnswerStyle.multipleChoice, textChoices: secondchoices)
    let secondQuestion = "Are you experiencing any of the following symptoms? Choose any/all that apply."
    
    let secondQuestionStep = ORKQuestionStep.init(identifier: "TextChoiceQuestionStepsecond", title: "COVID-19", question: secondQuestion, answer: secondAnswerFormat)
    secondQuestionStep.isOptional = false
       steps += [secondQuestionStep]
    
    
    let thirdchoice1 = "I am 65 years old or older"
    let thirdchoice2 = "I have a condition that affects my immune system (for example, HIV/AIDS, lupus, other autoimmune disorder)"
    let thirdchoice3 = "I have a chronic health condition (for example, diabetes, emphysema, asthma, heart condition)"
    let thirdchoice4 = "I am getting treatment that affects my immune system (for example, chemotherapy, corticosteroids, TNF inhibitors)"
    
    let thirdchoices: [ORKTextChoice] = [ORKTextChoice(text: thirdchoice1, value: thirdchoice1 as NSCoding & NSCopying & NSObjectProtocol),
    ORKTextChoice(text: thirdchoice2, value: thirdchoice2 as NSCoding & NSCopying & NSObjectProtocol),
    ORKTextChoice(text: thirdchoice3, value: thirdchoice3 as NSCoding & NSCopying & NSObjectProtocol),
    ORKTextChoice(text: thirdchoice4, value: thirdchoice4 as NSCoding & NSCopying & NSObjectProtocol)]
    
    let thirdAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: ORKChoiceAnswerStyle.singleChoice, textChoices: thirdchoices)
    let thirdQuestion = "Do any of the following apply to you?"
    
    let thirdQuestionStep = ORKQuestionStep.init(identifier: "TextChoiceQuestionStepthird", title: "COVID-19", question: thirdQuestion, answer: thirdAnswerFormat)
    thirdQuestionStep.isOptional = false
    steps += [thirdQuestionStep]
    
    
    let fourthAnswerFormat = ORKBooleanAnswerFormat()
    let fourthquestion = "Have you travelled outside of your Country/City in the last 14 days?"
    let fourthQuestionStep = ORKQuestionStep.init(identifier: "TextChoiceQuestionStepfourth", title: "COVID-19", question: fourthquestion, answer: fourthAnswerFormat)
    fourthQuestionStep.isOptional = false
    steps += [fourthQuestionStep]
    
    let fifthchoice1 = "is sick with new respiratory symptoms?"
    let fifthchoice2 = "recently travelled outside of your Country?"
    let fifthchoice3 = "close contact with tested positive for COVID-19"
    
    let fifthchoices: [ORKTextChoice] = [ORKTextChoice(text: fifthchoice1, value: fifthchoice1 as NSCoding & NSCopying & NSObjectProtocol),
    ORKTextChoice(text: fifthchoice2, value: fifthchoice2 as NSCoding & NSCopying & NSObjectProtocol),
    ORKTextChoice(text: fifthchoice3, value: fifthchoice3 as NSCoding & NSCopying & NSObjectProtocol)]
    
    let fifthAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: ORKChoiceAnswerStyle.singleChoice, textChoices: fifthchoices)
    let fifthQuestion = "Are you in close contact with a person who either:"

    let fifthQuestionStep = ORKQuestionStep.init(identifier: "TextChoiceQuestionStepfive", title: "COVID-19", question: fifthQuestion, answer: fifthAnswerFormat)
    fifthQuestionStep.isOptional = false
    steps += [fifthQuestionStep]
    
    // Summary step
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "COVID-19 Results."
    summaryStep.text = "Thank you for your contribution in self Assessement. Please wait for the results"
    steps += [summaryStep]
    

    // Create an ordered task with a single question.
    let task = ORKOrderedTask(identifier: "WithdrawTask", steps: steps)

    return task
}



