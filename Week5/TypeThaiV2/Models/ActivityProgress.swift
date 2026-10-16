//
//  ActivityProgress.swift
//  TypeThaiV2
//
//  Created by Siksaka Suriyasat on 10/9/26.
//
import SwiftData

@Model
final class ActivityProgress {
    var lessonID: String
    var activityID: String
    var stepsCompleted: Int
    var completed: Bool
    
    init(lessonID: String, activityID: String, stepsCompleted: Int, completed: Bool) {
        self.lessonID = lessonID
        self.activityID = activityID
        self.stepsCompleted = stepsCompleted
        self.completed = completed
    }
}

@Model
class SavedWords {
    var front: String
    var back: String
    
    init(front:String,back:String){
        self.front = front
        self.back = back
    }
}
