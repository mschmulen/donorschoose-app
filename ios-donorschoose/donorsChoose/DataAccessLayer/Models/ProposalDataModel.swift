
import Foundation

public struct GradeLevelModel {
  let id:String
  let name:String
}

public struct MatchingFundModel {
  let amount:String
  let description:String
  let donorSalutation:String
  let faqURL:String
  let logoURL:String
  let matchingKey:String
  let name:String
  let ownerRegion:String
  let type:String
}

public struct ResourceModel {
  let id:String
  let name:String
}

public struct SchoolTypeModel {
  let id:String
  let name:String
}

public struct SubjectModel {
  let subject:String// =
  let groupId:String// = 1;
  let id:String// = 11;
  let name:String// = "Visual Arts";
}

public struct ZoneModel {
  let id:String
  let name:String
}

public struct ProposalDataModel {

  public let id:String
  public let title: String
  public let teacherID: String
  public let teacherName: String
  public let schoolName: String
  public let state: String
  public let city: String
  public let costToComplete:String
  public let numDonors:Int
  public let percentFunded:Int
  public let proposalURL:String
  public let fulfillmentTrailer:String
  public let fundingStatus:String
  public let gradeLevel:GradeLevelModel
  public let imageURL:String?
  public let latitude:String
  public let longitude:String
  public let thumbImageURL:String?
  public let povertyLevel:String
  public let schoolUrl:String
  public let extractedSchoolID:String?
  public let totalPrice:String
  public let zip:String
  public let expirationDate:Date
  public let freeShipping:Bool
  public let fundURL:String?
  public let shortDescription:String

  //requires showSynopsis = true
  public let synopsis:String?

  //requires showFacetCounts = true
  //let showFacetCounts

  //
  //let proposalType:ProposalType?

  /*
   matchingFund =     {
   amount = "0.00";
   description = "";
   donorSalutation = "";
   faqURL = "";
   logoURL = "";
   matchingKey = "";
   name = "";
   ownerRegion = "";
   type = "";
   };
   */

  /* optional
   thankYouAssets
   interimThankYou
   photos***
   resultsLetter	string
   array
   string	If available, the following fields are provided:
   Interim Thank You Letter
   Photos (an array of URL’s)
   Results Letter
   */

  init( id:String, title:String,
        teacherID:String,
        teacherName:String,
        schoolName:String,
        state:String,
        city:String,
        costToComplete:String,
        numDonors:Int,
        percentFunded:Int,
        proposalURL:String,
        fulfillmentTrailer:String,
        fundingStatus:String,
        gradeLevel:GradeLevelModel,
        imageURL:String?,
        latitude:String,
        longitude:String,
        thumbImageURL:String?,
        povertyLevel:String,
        schoolUrl:String,
        extractedSchoolID:String?,
        //subjectString:String
    totalPrice:String,
    zip:String,
    expirationDate:Date,
    freeShipping:Bool,
    fundURL:String?,
    shortDescription:String,
    synopsis:String?
    ) {
    self.id = id
    self.title = title
    self.teacherID = teacherID
    self.teacherName = teacherName
    self.schoolName = schoolName
    self.state = state
    self.city = city
    self.costToComplete = costToComplete
    self.numDonors = numDonors
    self.percentFunded = percentFunded
    self.proposalURL = proposalURL
    self.fulfillmentTrailer = fulfillmentTrailer
    self.fundingStatus = fundingStatus
    self.gradeLevel = gradeLevel
    self.imageURL = imageURL
    self.latitude = latitude
    self.longitude = longitude
    self.thumbImageURL = thumbImageURL
    self.povertyLevel = povertyLevel
    self.schoolUrl = schoolUrl
    self.extractedSchoolID = extractedSchoolID
    //self.subjectString = subjectString
    self.totalPrice = totalPrice
    self.zip = zip
    self.expirationDate = expirationDate
    self.freeShipping = freeShipping
    self.fundURL = fundURL
    self.shortDescription = shortDescription
    self.synopsis = synopsis
  }

}

extension ProposalDataModel {

}


protocol JSONParser {
  static func obtainModel(from json: JSONObjectBase) -> Self?
}

// Conforming to the new protocol
extension ProposalDataModel: JSONParser {

  static func obtainModel(from json: JSONObjectBase) -> ProposalDataModel? {

    guard let title = json["title"] as? String,
      let id = json["id"] as? String,
      let fulfillmentTrailer = json["fulfillmentTrailer"] as? String,
      let teacherID = json["teacherId"] as? String,
      let teacherName = json["teacherName"] as? String,
      let schoolName = json["schoolName"] as? String,
      let state = json["state"] as? String,
      let city = json["city"] as? String,
      let costToComplete = json["costToComplete"] as? String,
      let proposalURL = json["proposalURL"] as? String,
      let numDonorsAsString = json["numDonors"] as? String,
      let numDonors = Int(numDonorsAsString),
      let percentFundedAsString = json["percentFunded"] as? String,
      let percentFunded = Int(percentFundedAsString),
      let fundingStatus = json["fundingStatus"] as? String,
      let povertyLevel = json["povertyLevel"] as? String,
      let schoolUrl = json["schoolUrl"] as? String,
      //let subjectString = json["percentFunded"] as? String,
      let shortDescription = json["shortDescription"] as? String
      else {
        return nil
    }

    // process the school url to extract the school ID
    // "https://www.donorschoose.org/school/roosevelt-elementary-school/16576/";

    /*
     extractedSchoolID = "333"
     }
     */

    var extractedSchoolID = "123"

    if let _ = URL(string: schoolUrl) { // validURL

      let schoolURLpaths = schoolUrl.components(separatedBy: "/")

      /*
       for ( pathComp )in schoolURLpaths {
       }
       if let lastPath = schoolURLpaths.last {
       //extractedSchoolID = lastPath
       }
       */

      // MAS TODO , Fix This
      let secondLastPath = schoolURLpaths[schoolURLpaths.count - 2]
      extractedSchoolID = secondLastPath
    }

    // MAS TODO cleanup
    /*
     guard let freeShipping = json["freeShipping:Bool"] as? Bool,
     else {
     return nil
     }
     */

    /*
     guard let zip = json["zip"] as? String else {
     return nil
     }
     */

    /*
     //serialize the GradeLevelModel
     guard let gLevel = json["gradeLevel"] as JSONObjectBase,
     let gLevelID = gLevel["id"] as? String,
     let gLevelName = gLevel["name"] as? String else {
     return nil
     }
     let gLevelModel = GradeLevelModel(id: gLevelID , name: gLevelName)
     */
    let gLevelModel = GradeLevelModel(id:"666" , name: "mock")

    //location
    guard let latitudeString = json["latitude"] as? String,
      let longitudeString = json["longitude"] as? String
      else {
        return nil
    }

    //total price
    guard let totalPriceString = json["totalPrice"] as? String else {
      return nil
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    guard let expirationDateString = json["expirationDate"] as? String,
      let expDate = dateFormatter.date(from: expirationDateString) else {
        return nil
    }
    
    // optionals
    let imageURL = json["imageURL"] as? String
    let thumbImageURL = json["thumbImageURL"] as? String
    let fundURL = json["fundURL"] as? String

    let synopsisString = json["synopsis"] as? String

    // process facets
    return ProposalDataModel(
      id:id,
      title: title,
      teacherID: teacherID,
      teacherName:teacherName,
      schoolName: schoolName,
      state:state,
      city:city,
      costToComplete:costToComplete,
      numDonors:numDonors,
      percentFunded:percentFunded,
      proposalURL:proposalURL,
      fulfillmentTrailer:fulfillmentTrailer,
      fundingStatus:fundingStatus,
      gradeLevel: gLevelModel,
      imageURL : imageURL,
      latitude:latitudeString,
      longitude:longitudeString,
      thumbImageURL: thumbImageURL,
      povertyLevel:povertyLevel,
      schoolUrl:schoolUrl,
      extractedSchoolID:extractedSchoolID,
      //subjectString:subjectString,
      totalPrice: totalPriceString,
      zip:"zip",
      expirationDate: expDate,
      freeShipping: false, //freeShipping,
      fundURL: fundURL,
      shortDescription:shortDescription,
      synopsis: synopsisString
    )
  }
}

