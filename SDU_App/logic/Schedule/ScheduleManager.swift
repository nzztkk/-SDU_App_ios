//
//  ScheduleManager.swift
//  SDU App
//
//  Created by Nurkhat on 19.09.2024.
//

import Foundation

class ScheduleManager {
    
    
    
    static let shared = ScheduleManager() // Singleton для использования в любом месте приложения
    
    private init() {}
    
    // Полное расписание курсов
    func getCourses() -> [CourseNtfy] {
        return [
            CourseNtfy(day: "day_mon".weeks, startTime: "ct_1_start".lc, name: "c_name_mde_151".lc, location: "cr_a1".lc),
            CourseNtfy(day: "day_mon".weeks, startTime: "ct_3_start".lc, name: "c_name_css_410".lc, location: "cr_a2".lc),
            CourseNtfy(day: "day_mon".weeks, startTime: "ct_4_start".lc, name: "c_name_css_410".lc, location: "cr_a2".lc),
            CourseNtfy(day: "day_mon".weeks, startTime: "ct_8_start".lc, name: "c_name_css_410".lc, location: "cr_a3".lc),
            CourseNtfy(day: "day_tues".weeks, startTime: "ct_9_start".lc, name: "c_name_css_312".lc, location: "cr_e1".lc),
            CourseNtfy(day: "day_wednes".weeks, startTime: "ct_8_start".lc, name: "c_name_inf_405".lc, location: "cr_a1".lc),
            CourseNtfy(day: "day_wednes".weeks, startTime: "ct_9_start".lc, name: "c_name_inf_405".lc, location: "cr_a1".lc),
            CourseNtfy(day: "day_wednes".weeks, startTime: "ct_10_start".lc, name: "c_name_inf_405".lc, location: "cr_a1".lc),
            CourseNtfy(day: "day_thurs".weeks, startTime: "ct_5_start".lc, name: "c_name_inf_228".lc, location: "cr_b2".lc),
            CourseNtfy(day: "day_thurs".weeks, startTime: "ct_6_start".lc, name: "c_name_inf_228".lc, location: "cr_b2".lc),
            CourseNtfy(day: "day_fri".weeks, startTime: "ct_1_start".lc, name: "c_name_css_312".lc, location: "cr_f1".lc),
            CourseNtfy(day: "day_fri".weeks, startTime: "ct_2_start".lc, name: "c_name_css_312".lc, location: "cr_f1".lc),
            CourseNtfy(day: "day_fri".weeks, startTime: "ct_3_start".lc, name: "c_name_inf_228".lc, location: "cr_g1".lc),
            CourseNtfy(day: "day_satur".weeks, startTime: "ct_1_start".lc, name: "c_name_css_319".lc, location: "cr_d1".lc),
            CourseNtfy(day: "day_satur".weeks, startTime: "ct_2_start".lc, name: "c_name_css_319".lc, location: "cr_d1".lc),
            CourseNtfy(day: "day_satur".weeks, startTime: "ct_7_start".lc, name: "c_name_css_319".lc, location: "cr_d1".lc)
        ]
    }
}
