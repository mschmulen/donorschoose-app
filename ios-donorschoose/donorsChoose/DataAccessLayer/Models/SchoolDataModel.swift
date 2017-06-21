// SchoolDataModel.swift

import Foundation

// https://data.donorschoose.org/docs/school-pages/

public struct SchoolDataModel {
  //imutable always provided
  let id: String
  let name: String
  let schoolURL: String
  //let gradeType: Object
  // gradeType[id]
  // gradeType[name]
  let povertyLevel:String
  let city:String
  let zip:String
  let state:String
  // latitude
  // longitude
  // zone:object
  //zone[id]
  //zone[name]
  let totalProposals:String

  init( id:String,
        name:String,
        schoolURL:String,
        povertyLevel:String,
        city:String,
        state:String,
        zip:String,
        totalProposals:String
    ) {

    self.id = id
    self.name = name
    self.schoolURL = schoolURL
    self.povertyLevel = povertyLevel
    self.city = city
    self.zip = zip
    self.state = state
    self.totalProposals = totalProposals
  }

}

// Conforming to the new protocol
extension SchoolDataModel: JSONParser {

  static func obtainModel(from json: JSONObjectBase) -> SchoolDataModel? {

    guard let id = json["id"] as? String,
      let name = json["name"] as? String,
      let schoolURL = json["schoolURL"] as? String,
      let povertyLevel = json["povertyLevel"] as? String,
      let city = json["city"] as? String,
      let state = json["state"] as? String,
      let zip = json["zip"] as? String,
      let totalProposals = json["totalProposals"] as? String
      else {
        return nil
    }

    return SchoolDataModel(id: id, name: name, schoolURL: schoolURL, povertyLevel: povertyLevel, city: city, state: state,zip:zip, totalProposals:totalProposals
    )

  }
}

