
//  WatchListModels.swift

import Foundation

public enum WatchItemEventSourceType {
    case watchlist_ADD
    case detail_LOOK
    case donate_PRESS
}

public enum WatchItemType : String {
    case PROPOSAL = "POPOSAL"
    case TEACHER = "TEACHER"
    case SCHOOL = "SCHOOL"
    case CUSTOM_SEARCH = "CUSTOM_SEARCH"
    case UNKNOWN = "UNKNOWN"
}

extension WatchItemType : ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String){
        self.init(rawValue: value)!
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

public protocol WatchItemProtocol {
    var UUID: String { get set }
    var type: WatchItemType { get set}
    var title: String { get set }
    var modelID: String { get set }
    var deadline: Date? { get set }
    
    var searchModel:ProjectSearchDataModel { get }
}


open class WatchItemUnknown : WatchItemProtocol {
    open var title: String
    open var type: WatchItemType
    open var modelID:String
    open var UUID: String
    open var deadline: Date? = nil
    
    init(title: String, modelID:String ,UUID: String) {
        self.title = title
        self.type = WatchItemType.UNKNOWN
        self.modelID = modelID
        self.UUID = UUID
    }
    
    public var searchModel:ProjectSearchDataModel {
        return ProjectSearchDataModel(type: .urgent, keywordString: "", pageSize:5)
    }

}

open class WatchItemCustomSearch : WatchItemProtocol {
    open var title: String
    open var type: WatchItemType
    open var modelID:String
    open var UUID: String
    open var deadline: Date? = nil
    open var searchString: String
    //public var searchSortOption: SEARCH_SORT_OPTION
    
    init(title: String, modelID:String , searchString: String){//, searchSortOption:SEARCH_SORT_OPTION) {
        self.title = title
        self.type = WatchItemType.CUSTOM_SEARCH
        self.modelID = modelID
        self.UUID = modelID
        self.searchString = searchString
        //self.searchSortOption = searchSortOption
    }
    
    public var searchModel:ProjectSearchDataModel {
        return ProjectSearchDataModel(type: .keyword, keywordString: title, pageSize:5)
    }
    
}


open class WatchItemTeacher : WatchItemProtocol {
    open var title: String
    open var type: WatchItemType
    open var modelID:String
    open var UUID: String
    open var deadline: Date? = nil
    
    init(title: String, modelID:String ,UUID: String ) {
        self.title = title
        self.type = WatchItemType.TEACHER
        self.modelID = modelID
        self.UUID = UUID
    }
    
    public var searchModel:ProjectSearchDataModel {
        return ProjectSearchDataModel(type: .urgent, keywordString: title, pageSize:5)
    }

}

open class WatchItemSchool : WatchItemProtocol {
    open var UUID: String
    open var type: WatchItemType
    open var title: String
    open var modelID:String
    open var deadline: Date? = nil
    
    init(title: String, modelID:String ,UUID: String) {
        self.title = title
        self.type = WatchItemType.SCHOOL
        self.modelID = modelID
        self.UUID = UUID
    }
    
    public var searchModel:ProjectSearchDataModel {
        return ProjectSearchDataModel(type: .urgent, keywordString: title, pageSize:5)
    }
    
}

open class WatchItemProposal : WatchItemProtocol {
    
    open var UUID: String
    open var type: WatchItemType
    open var title: String
    open var modelID:String
    open var deadline: Date?
    
    var isOverdue: Bool {
        if let _deadline = deadline {
        // Optionally, you can omit "NSComparisonResult" and just type .OrderDescending
            return (Date().compare(_deadline) == ComparisonResult.orderedDescending) // deadline is earlier than current date
        }
        else {
            return false
        }
    }
    
    init(title: String, modelID:String ,UUID: String, deadline: Date? ) {
        self.title = title
        self.type = WatchItemType.PROPOSAL
        self.modelID = modelID
        self.UUID = UUID
        self.deadline = deadline
    }
    
    public var searchModel:ProjectSearchDataModel {
        return ProjectSearchDataModel(type: .urgent, keywordString: title, pageSize:5)
    }

}
