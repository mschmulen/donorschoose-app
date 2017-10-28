

// MAS TODO Remove me

//import ReactiveSwift
//import enum Result.NoError

//protocol ViewDataProtocol {
//  static var empty: Self { get }
//}
//
//extension Optional: ViewDataProtocol {
//  static var empty: Optional {
//    return .none
//  }
//}
//
//extension Array: ViewDataProtocol {
//  static var empty: Array {
//    return []
//  }
//}
//
//protocol ViewDataObserving: class {
//  associatedtype ViewData: ViewDataProtocol
//
//  var viewData: MutableProperty<ViewData> { get }
//
//  func viewDataDidChange(from old: ViewData, to new: ViewData)
//}
//
//extension ViewDataObserving {

//  func observe<P: PropertyProtocol>(_ viewData: P) where P.Value == ViewData {
//    self.viewData <~ viewData
//  }
//
//  func observeViewDataChanges(until trigger: Signal<(), NoError>) {
//    viewData.producer
//      .combinePrevious(.empty)
//      .take(until: trigger)
//      .startWithValues { [weak self] old, new in
//        self?.viewDataDidChange(from: old, to: new)
//    }
//  }

  //  func startVD() {
  //    viewData.producer
  //      .combinePrevious(.empty)
  //      .startWithValues { [weak self] old, new in
  //        self?.viewDataDidChange(from: old, to: new)
  //    }
  //  }
  //
  //  func stopVD() {
  //
  //  }
  
//}

