//
//  Network.swift
//  currency-converter
//
//  Created by AGM Tazim on 03/05/22.
//

import Foundation

enum SearchApiRequest {
    case searchMovie(params: Parameterizable)
}

extension SearchApiRequest: APIRequest {
    public var baseURL: URL {
        let url =  "\(AppConfig.shared.getServerConfig().getBaseUrl())/\(AppConfig.shared.getServerConfig().getApiVersion())/"
        return URL(string: url)!
    }
    
    public typealias ItemType = Movie
    public typealias ResponseType = SearchResponse<ItemType>
    
    public var method: RequestType {
        switch self {
            case .searchMovie: return .GET
        }
    }
    
    public var path: String {
        switch self {
            case .searchMovie: return "search/movie"
        }
    }
    
    public var parameters: [String: Any]{
        var parameter: [String: Any] = [:]
        
        switch self {
            case .searchMovie (let params):
                parameter = params.asRequestParam
        }
        
        return parameter
    }
    
    public var headers: [String: String] {
        return [String: String]()
    }
}


