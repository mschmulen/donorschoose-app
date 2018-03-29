
import Foundation
import CoreLocation


public struct LocationInfo : Codable, UserDefaultStorable {
    let city:String
    let state:String
    let zip:String
    let countryCode:String
}

public struct ProjectSearchDataModel : Codable, UserDefaultStorable {
    
    var type:SearchModelType
    var sortOption:SearchSortOption
    var pageSize:Int
    
    var keywords:String?
    var subject1:SearchSubject?
    
    // location info
    var latitude:Double?
    var longitude:Double?
    var locationInfo:LocationInfo?
    
    public init(type:SearchModelType,  keywordString:String? , pageSize:Int = 20) {
        self.type = type
        self.pageSize = pageSize
        self.keywords = keywordString
        
        self.subject1 = nil
        switch type {
        case .urgent:
            self.sortOption = .urgency
        case .inspiresUser:
            self.sortOption = .newest
        case .keyword:
            self.sortOption = .newest
        case .locationLatLong:
            self.sortOption = .newest
        }
    }


    public enum SearchSortOption:Int, Codable {
        case urgency = 0
        case poverty = 1
        case lowest_COST = 2
        case popularity = 4
        case expiration = 5
        case newest = 7
        
        func requestValue() -> Int {
            switch ( self ) {
            case .urgency : return 0
            case .poverty: return 1
            case .lowest_COST: return 2
            case .popularity: return 4
            case .expiration: return 5
            case .newest: return 7
            }
        }//end subject1
        
        static let pickerOptions:[SearchSortOption] = [ .urgency, .popularity ,.expiration ]
        
        static func enumFromRowValue(_ row:Int) -> SearchSortOption {
            switch row {
            case 1: return .urgency
            case 2: return .poverty
            case 3: return .lowest_COST
            case 4: return .popularity
            case 5: return .expiration
            default: return .newest
            }
        }
        
        var shortLabel: String {
            switch self {
            case .urgency: return "urgency first"
            case .poverty: return "poverty first"
            case .lowest_COST: return "lowest cost to complete"
            case .popularity: return "popularity"
            case .expiration: return "expiring first"
            case .newest: return "newest first"
            }
        }
        
        var pickerLabel: String {
            switch self {
            case .urgency: return "Show high urgency first" // shows projects with higher urgency
            case .poverty: return "Show highest poverty first" //Poverty shows projects from schools with the highest levels of poverty at the top
            case .lowest_COST: return "Show by lowest cost to complete" //Cost shows projects with the lowest cost to complete at the top
            case .popularity: return "Show by popularity"//Popularity shows projects with higher numbers of donors at the top
            case .expiration: return "Show expiring first" //Expiration shows projects that are closest to expiring
            case .newest: return "Show newest first" //Newest shows projects that were created most recently
            }
        }
    }
    
    public enum SearchSubject:Int,Codable {
        
        case music_AND_THE_ARTS = -1
        // case PERFORMING_ARTS
        // case VISUAL_ARTS
        // case MUSIC
        
        case health_AND_SPORTS = -2
        // Sports
        // Health & Wellness
        // Nutrition
        // Gym & Fitness
        
        case literacy_AND_LANGUAGE = -6
        // Literacy
        // Literature & Writing
        // Foreign Languages
        // ESL    subject6=-6
        
        case history_AND_CIVICS = -3
        // History & Geography
        // Civics & Government
        // Economics
        // Social Sciences    subject3=-3
        
        case math_AND_SCIENCE =  -4
        // Health & Life Science
        // Applied Science
        // Environmental Science
        // Mathematics    subject4=-4
        
        case special_NEEDS = -7
        
        case applied_LEARNING = -5
        // Early Development
        // Community Service
        // Character Education
        // College & Career Prep
        // Extra Curricular
        // Parental Involvement
        // Other    subject5=-5
        
        func subject1() -> Int {
            switch ( self ) {
            case .music_AND_THE_ARTS : return -1
            case .health_AND_SPORTS : return -2
            case .literacy_AND_LANGUAGE : return -6
            case .history_AND_CIVICS : return -3
            case .math_AND_SCIENCE : return -4
            case .special_NEEDS: return -7
            case .applied_LEARNING: return -5
            }
        }//end subject1
    }
    
    public enum SearchModelType : Int, Codable {
        case urgent = 0
        case locationLatLong = 1
        case keyword = 2
        // MAS TOOD Remove ( use the keyword )
        case inspiresUser
    }
    
}

extension ProjectSearchDataModel: Hashable {
    
    public var hashValue: Int {
        return type.hashValue ^ sortOption.hashValue ^ (keywords ?? "").hashValue // ^ (subject1 ?? 0)
        // return model.type.hashValue ^ (model.keywords ?? "").hashValue
        // return [model.type, (model.keywords ?? "").hashValue ].hashValue
    }
    
    public static func == (lhs: ProjectSearchDataModel, rhs: ProjectSearchDataModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}


//    // MAS TODO ... matt clean this up as static class funcs ... not initializers
////    init( pListName: String ) {
////        if let plist = Plist(name: pListName) {
////            self.plist = plist
////            //let dict = plist.getMutablePlistFile()!
////            //dict["keyword"] = self.keywords
////            //dict["sortOption"] = SEARCH_SORT_OPTION.NEWEST.hashValue
////            //dict["subject"] = nil
////            /*
////             do {
////             try plist.addValuesToPlistFile(dict)
////             } catch {
////             }
////             */
////
////            if let currentValues = plist.getValuesInPlistFile() {
////                //load the valuse
////                if let keywordString = currentValues["keyword"] as? String {
////                    self.keywords = keywordString
////                }
////                else {
////                    self.keywords = "Austin"
////                }
////
////                // MAS TODO
////                //if let sortOptionValue = currentValues["keyword"] as? String
////                self.sortOption = SEARCH_SORT_OPTION.newest
////                subject1 = nil
////            }
////            else {
////                self.keywords = "Austin"
////                self.sortOption = SEARCH_SORT_OPTION.newest
////                subject1 = nil
////            }
////        }
////        else {
////            self.keywords = "Austin"
////            self.sortOption = SEARCH_SORT_OPTION.newest
////            subject1 = nil
////        }
////
////        self.type = .keyword
////    }
////    public func save (_ pListName: String ){
////
////        if let plist = Plist(name: pListName) {
////
////            let dict = plist.getMutablePlistFile()!
////            dict["keyword"] = self.keywords
////            dict["sortOption"] = SEARCH_SORT_OPTION.newest.hashValue
////
////            do {
////                try plist.addValuesToPlistFile(dict)
////            } catch { }
////        }
////        else { }
////    }

