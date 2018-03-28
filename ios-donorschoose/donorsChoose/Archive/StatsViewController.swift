
import UIKit

open class StatsViewController: UIViewController {

  // MAS TODO convert to optional function callback architecture.
//  var fetch: (() -> Void)?
//  var fetchMake: (() -> Void)?
//  var submit: ((FIRYacht) -> Void)?
//  var cancel: (() -> Void)?

  @IBOutlet weak var viewChart: UIView!

  @IBOutlet weak var labelStudentsHelped: UILabel! {
    didSet {
      labelStudentsHelped.text = "Students Reached:"
    }
  }

  @IBOutlet weak var labelSchoolsHelped: UILabel! {
    didSet {
      labelSchoolsHelped.text = "Schools Helped:"
    }
  }

  @IBOutlet weak var labelNumDonors: UILabel! {
    didSet {
      labelNumDonors.text = "Number of Donors:"
    }
  }

  @IBOutlet weak var labelTotalDonations: UILabel! {
    didSet {
      labelTotalDonations.text = "Total Donations:"
    }
  }

  // MARK: - properties
  let apiConfig = APIConfig()
  let data:String

  var dataAPI:DonorPageDataAPIProtocol?

  // MARK: - data
  var model:DonorPageDataModel? = nil {
    didSet {
      if let model = model {
        //update the UI Components
        DispatchQueue.main.async {
          self.labelStudentsHelped.text = "Students Reached: \(model.studentsReached)"
          self.labelSchoolsHelped.text = "Schools Helped: \(model.numSchools)"
          self.labelNumDonors.text = "Number of Donors: \(model.numDonors)"
          self.labelTotalDonations.text  = "Total Donations: $\(model.amountDonated)"
        }
      }
    }
  }

  // MARK: - methods

  // MARK: - VCLifeCycle
  override open func viewDidLoad() {
    super.viewDidLoad()

    dataAPI = DonorPageDataAPI(config: apiConfig, user: "matt", delegate: self)
    dataAPI?.getStats(apiConfig.givingPageID)
  }

  override open func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  override open func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  // MARK: - init
  required public init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, data:String) {
    self.data = data
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  public convenience init( data:String )
  {
    //self.init(nibName: nil, bundle: nil, dataURL: dataURL)
    self.init(nibName: "StatsViewController", bundle: Bundle(for: StatsViewController.self), data:data )
  }

}

// MARK: - DonorPageDataAPIDelegate
extension StatsViewController : DonorPageDataAPIDelegate {

  public func dataUpdateCallback( _ dataAPI: DonorPageDataAPIProtocol, didChangeData data:DonorPageDataModel?, error:APIError? ) {

    if let someError = error {
      if let alertVC = AlertFactory.AlertFromError(someError) {
        self.present(alertVC, animated: true, completion: nil)
      }
    }
    else {
      if let dataModel = data {
        self.model = dataModel
      }
    }
  }
}

public extension StatsViewController {

  // MAS TODO Cleanup 
//  public static func factoryNav(_ model: FIRYacht? = nil) -> UINavigationController {
//    let vc = YachtViewController.factory(model)
//    let nvc = NavControllerViewController(rootViewController: vc)
//    nvc.tabBarItem = UITabBarItem(title: "Yacht Detail" , image:UIImage(named:"part"), tag:1)
//    return nvc
//  }

//  public static func factory(_ model: FIRYacht? = nil) -> YachtViewController {
//    let vm = YachtViewModel(providerType: defaultProviderType, model:model )
//    let vc = YachtViewController()
//    vc.observe(vm.viewData)
//
//    vc.fetch = {
//      vm.fetch()
//    }
//    vc.fetchMake = {
//      vm.fetchMake()
//    }
//    vc.cancel = {
//      // MAS TODO HANDLE CANCEL ?
//    }
//    //    vc.submit = { data in
//    //      vm.submitNew( data )
//    //    }
//    vc.editString = { (record,value) in
//      vm.updatePropertyString(record, newValue: value)
//    }
//    vc.editFloat = { (record, value) in
//      vm.updatePropertyFloat(record,newValue: value)
//    }
//
//    vm.showError = { error in
//      vc.showError(error)
//    }
//    vm.log = { message in
//    }
//
//    //    vm.submitComplete = {
//    //
//    //      if let nvc = vc.navigationController {
//    //        nvc.popViewController(animated: true)
//    //      }
//    //      else {
//    //        vc.dismiss(animated: true, completion: nil)
//    //      }
//    //    }
//
//    // MAS TODO Remove
//    if (model == nil ) {
//      vm.new()
//    }
//    
//    return vc
//  }

}




