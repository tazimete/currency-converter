//
//  SearchCellViewModel.swift
//  setScheduleTest
//
//  Created by JMC on 4/11/21.
//

import Foundation


class SearchCellViewModel: AbstractCellViewModel {
    var id: Int?
    var thumbnail: String?
    var title: String?
    var overview: String?
    
    init(id: Int? = nil, thumbnail: String? = nil, title: String? = nil, overview: String? = nil) {
        self.id = id
        self.thumbnail = thumbnail
        self.title = title
        self.overview = overview
    }
}

