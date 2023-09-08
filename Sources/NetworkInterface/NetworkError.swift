public enum NetworkError: Error {
     case invalidHttpURLResponse
     case invalidResponseData
 }


public enum NetworkRequestError: Error {
    case invalidPathComponents
    case invalidUrl
}
