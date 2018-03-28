
import Foundation

protocol Path {
  var path: String { get }
}

protocol AppPath: Path {
  var baseURL: URL { get }
}

enum AppRoute {
  case Splash
  case Teacher(id:String)
  case Project(id:String)
  case School(id:String)
}

extension AppRoute : AppPath {
  var baseURL: URL { return URL(string: "https://www.donorschoose.org")! }

  var path: String {
    switch self {
    case .Splash: return "/splash"
    case .Teacher(let id): return "/teacher/\(id)"
    case .Project(let id): return "/project/\(id)"
    case .School(let id): return "/school/\(id)"
    }
  }

  var url: URL {
    return baseURL.appendingPathComponent(path)
  }

  var identifier: String? {
    switch self {
    case .Splash: return nil
    case .Teacher(let id):
      return id
    case .Project(let id):
      return id
    case .School(let id):
      return id
    }
  }

  static func route(activity:NSUserActivity) -> AppRoute? {
    guard activity.activityType == NSUserActivityTypeBrowsingWeb,
      let url = activity.webpageURL,
      let route = AppRoute.route(url: url) else {
        return nil
    }
    return route
  }

  static func route(url:URL) -> AppRoute? {
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
      return nil
    }

    let pathComponents = components.path.components(separatedBy: "/")

    if pathComponents.contains("project") {
      if let id = pathComponents.last {
        return .Project(id: id)
      }
    }

    if pathComponents.contains("teacher") {
      if let id = pathComponents.last {
        return .Teacher(id: id)
      }
    }

    return .Splash
  }
  
}

