import Moya

public enum Marvel {
  // 1
  static private let publicKey = "c04329be99f9f97c89cad0d24e92e0fd" // PUBLIC_KEY
  static private let privateKey = "682c3d4963a58a36a6cb36ccbf844cf221d9511e" // PRIVATE_KEY
  
  // 2
  case comics
}

extension Marvel: TargetType {
  // 1
  public var baseURL: URL {
    return URL(string: "https://gateway.marvel.com/v1/public")!
  }
  
  // 2
  public var path: String {
    switch self {
    case .comics: return "/comics"
    }
  }
  
  // 3
  public var method: Moya.Method {
    switch self {
    case .comics: return .get
    }
  }
  
  // 4
  public var sampleData: Data {
    return Data()
  }
  
  // 5
  public var task: Task {
    let ts = "\(Date().timeIntervalSince1970"
    // 1
    let hash = (ts + Marvel.privateKey + Marvel.publicKey).md5
    
    // 2
    let authParams = ["apikey": Marvel.publicKey, "ts": ts, "hash": hash]
    
    switch self {
    case .comics:
      // 3
      return .requestParameters(
        parameters: [
          "format": "comic",
          "formatType": "comic",
          "orderBy": "-onsaleDate",
          "dateDescriptor": "lastWeek",
          "limit": 50] + authParams,
        encoding: URLEncoding.default)
    }
  }
  
  // 6
  public var headers: [String: String]? {
    return ["Content-Type": "application/json"]
  }
  
  // 7
  public var validationType: ValidationType {
    return .successCodes
  }
}
