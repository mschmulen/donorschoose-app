
import Foundation

public struct DonationMessage {
  let message:String
  let tagline:String
}

public struct DonorPageDataModel {

  enum ChallengeType: String {
    case Challenge
  }

  let id: String
  let name: String

  let amountDonated:String
  let challengeImage:String
  let challengeMessage:String
  let challengeURL:String
  let numDonors:String
  let numFundedProposals:Int
  let numSchools:Int
  let numTeachers:Int
  let studentsReached: Int
  let totalProposals: String
  let totalSupporters: String
  let donationMessages: Array<DonationMessage>
}

extension DonorPageDataModel {

  init(json: [String: Any]) throws {

    // guarenteed, required
    guard let challengeId = json["challengeId"] as? String,
      let amountDonated = json["amountDonated"] as? String,
      let challengeImage = json["challengeImage"] as? String,
      let challengeMessage = json["challengeMessage"] as? String,
      let challengeName = json["challengeName"] as? String,
      let challengeURL = json["challengeURL"] as? String,
      let totalProposals = json["totalProposals"] as? String,
      let numFundedProposals = json["numFundedProposals"] as? Int,
      let numSchools = json["numSchools"] as? Int,
      let numTeachers = json["numTeachers"] as? Int,
      let numDonors = json["numDonors"] as? String,
      let studentsReached = json["studentsReached"] as? Int,
      let totalSupporters = json["totalSupporters"] as? String
      else {
        throw SerializationError.missing("critical properties")
    }

    var messages: Array<DonationMessage> = []
    if let donationMessages = json["donationMessages"] as? [String:Any] {
      for _ in donationMessages {
        let message = DonationMessage( message: "message", tagline: "yack")
        messages.append(message)
      }
    }

    self.id = challengeId
    self.name = challengeName
    self.amountDonated = amountDonated
    self.challengeImage = challengeImage
    self.challengeMessage = challengeMessage
    self.challengeURL = challengeURL
    self.donationMessages = messages
    self.studentsReached = studentsReached
    self.totalProposals = totalProposals
    self.totalSupporters = totalSupporters

    self.numDonors = numDonors
    self.numFundedProposals = numFundedProposals
    self.numSchools = numSchools
    self.numTeachers = numTeachers
  }
}

