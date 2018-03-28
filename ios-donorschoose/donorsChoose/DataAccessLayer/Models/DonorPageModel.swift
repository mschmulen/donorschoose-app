
import Foundation

public struct DonationMessage : Codable {
  let message:String
  let tagline:String
}

public struct DonorPageDataModel : Codable {
    
    let amountDonated:String
    // calcChallengeMetricsEnabled = 1;
    let challengeId:String
    // challengeImage = "https://cdn.donorschoose.net/images/project/blackboard.jpg";
    let challengeImage:String
    let challengeMessage:String// = "Welcome to my DonorsChoose.org Giving Page.  Please choose a project below to support, with a donation of any size!";
    let challengeName:String
    let challengeType:String // = Challenge;
    
    let challengeURL:String //= "https://www.donorschoose.org/giving/mobile-giving-page/20785042/?category=&utm_source=api&utm_medium=widget&utm_content=newproject&utm_campaign=Tech092208
    
    let donationMessages: Array<DonationMessage>
    
    let numDonors:String
    let numFundedProposals:Int
    let numSchools:Int
    let numTeachers:Int
    
//    primaryCategory =     {
//    id = 325;
//    name = "Create Your Own";
//    };
    
//    proposals =     (
//    {
//    city = "Cedar Hill";
//    costToComplete = "357.87";
//    expirationDate = "2018-04-03";
    
    let proposals: Array<ProposalModel>
    
    let studentsReached: Int
    let totalProposals: String
    let totalSupporters: String
}



