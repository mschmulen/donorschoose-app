
import Foundation

// https://data.donorschoose.org/docs/project-listing/json-requests/

public enum SEARCH_SORT_OPTION {
  case urgency
  case poverty
  case lowest_COST
  case popularity
  case expiration
  case newest

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

  static let pickerOptions = [ SEARCH_SORT_OPTION.urgency, SEARCH_SORT_OPTION.popularity ,SEARCH_SORT_OPTION.expiration ]

  static func enumFromRowValue(_ row:Int) -> SEARCH_SORT_OPTION {
    switch row {
    case 1: return .urgency
    case 2: return .poverty
    case 3: return .lowest_COST
    case 4: return .popularity
    case 5: return .expiration
    default: return .newest
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

public enum SEARCH_SUBJECT {

  case music_AND_THE_ARTS
  // case PERFORMING_ARTS
  // case VISUAL_ARTS
  // case MUSIC

  case health_AND_SPORTS
  // Sports
  // Health & Wellness
  // Nutrition
  // Gym & Fitness

  case literacy_AND_LANGUAGE
  // Literacy
  // Literature & Writing
  // Foreign Languages
  // ESL	subject6=-6

  case history_AND_CIVICS
  // History & Geography
  // Civics & Government
  // Economics
  // Social Sciences	subject3=-3

  case math_AND_SCIENCE
  // Health & Life Science
  // Applied Science
  // Environmental Science
  // Mathematics	subject4=-4

  case special_NEEDS

  case applied_LEARNING
  // Early Development
  // Community Service
  // Character Education
  // College & Career Prep
  // Extra Curricular
  // Parental Involvement
  // Other	subject5=-5

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

public enum SEARCH_MODEL_TYPE {
  case in_NEED
  case location
  case keyword
}


public struct SearchDataModel {

  public var type:SEARCH_MODEL_TYPE

  public var keywords: String {
    didSet {
      // MAS TODO, save on edit
      print("keywords was changed, save it to disk")
    }
  }
  public var sortOption:SEARCH_SORT_OPTION
  public var subject1:SEARCH_SUBJECT?

  fileprivate var plist: Plist?

  /*
   // In Need Parameters
   public let inNeed:Bool

   // Special Categories
   // High Level of Poverty Projects from high need and high poverty schools (40% or more students receive free lunch)
   public var highLevelPoverty:Bool?
   // Highest Level of Poverty Projects from highest need and highest poverty schools (65% or more students receive free lunch)
   public var highestLevelPoverty:Bool?
   */

  public init(type:SEARCH_MODEL_TYPE,  keywordString:String ) {
    self.type = type
    subject1 = nil
    self.keywords = keywordString

    if type == .in_NEED {
      self.sortOption = SEARCH_SORT_OPTION.urgency
    }
    else {
      self.sortOption = SEARCH_SORT_OPTION.newest
    }
  }

  // MAS TODO ... matt clean this up as static class funcs ... not initializers
  init( pListName: String ) {

    if let plist = Plist(name: pListName) {
      self.plist = plist
      
      //let dict = plist.getMutablePlistFile()!
      //dict["keyword"] = self.keywords
      //dict["sortOption"] = SEARCH_SORT_OPTION.NEWEST.hashValue
      //dict["subject"] = nil

      /*
       do {
       try plist.addValuesToPlistFile(dict)
       } catch {
       }
       */

      if let currentValues = plist.getValuesInPlistFile() {
        //load the valuse
        if let keywordString = currentValues["keyword"] as? String {
          self.keywords = keywordString
        }
        else {
          self.keywords = "Austin"
        }

        // MAS TODO
        //if let sortOptionValue = currentValues["keyword"] as? String
        self.sortOption = SEARCH_SORT_OPTION.newest
        subject1 = nil
      }
      else {
        self.keywords = "Austin"
        self.sortOption = SEARCH_SORT_OPTION.newest
        subject1 = nil
      }
    }
    else {
      self.keywords = "Austin"
      self.sortOption = SEARCH_SORT_OPTION.newest
      subject1 = nil
    }

    self.type = .keyword

  }

  public func save (_ pListName: String ){

    if let plist = Plist(name: pListName) {
      //self.plist = plist

      let dict = plist.getMutablePlistFile()!
      dict["keyword"] = self.keywords
      dict["sortOption"] = SEARCH_SORT_OPTION.newest.hashValue

      do {
        try plist.addValuesToPlistFile(dict)
      } catch {
//        log("save error: \(error)")
      }
    }
    else {
      //self.keywords = "Austin"
      //self.sortOption = SEARCH_SORT_OPTION.NEWEST
      //subject1 = nil
    }
  }
}
