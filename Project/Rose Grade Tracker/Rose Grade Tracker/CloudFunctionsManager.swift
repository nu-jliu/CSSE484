//
//  CloudFunctionsManager.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 4/30/22.
//

import Foundation
import Firebase

class CloudFunctionsManager {
    
    static let shared = CloudFunctionsManager()
    private var _functions: Functions
    
    private init() {
        self._functions = Functions.functions()
    }
    
    func getCourseTotalLetterGrade(courseId: String, callback: @escaping ((Double) -> Void)) {
        
        self._functions.httpsCallable("getCourseTotals").call(["courseId": courseId]) { res, err in
            if let err = err {
                print("HTTP Request ERROR: \(err)")
                return
            }
            
//            print("Received response: \(res?.data ?? "")")
            
            if let data = res?.data as? [String: Any] {
                if let grade = data["totalGrade"] as? Double {
                    callback(grade)
                }
            }
        }
    }
}
