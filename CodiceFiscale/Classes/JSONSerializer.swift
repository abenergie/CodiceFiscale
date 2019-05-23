//
//  JSONSerializer.swift
//  MyPIV
//
//  Created by Luigi Aiello on 06/02/2019.
//  Copyright © 2019 ABenergie S.p.A. All rights reserved.
//

import Foundation

class JSONSerializer {
    static func serializeFromFileJSON<T>(modelType: T.Type, input sourceName: String, type: String) -> T? where T: Decodable {
        guard let path = Bundle.main.path(forResource: sourceName, ofType: type) else {
            assertionFailure("Are you kidding me? I didn't found any files with this name: \(sourceName).\(type)")
            return nil
        }

        return serialiFromFile(modelType: modelType, path: path)
    }

    static func serializeFromPODFileJSON<T>(modelType: T.Type, input sourceName: String, type: String) -> T? where T: Decodable {
        let podBundle = Bundle(for: JSONSerializer.self)

        guard let path = podBundle.path(forResource: sourceName, ofType: type) else {
            return nil
        }

        return serialiFromFile(modelType: modelType, path: path)
    }
    
    static func serialize<T>(modelType: T.Type, data: Data?) -> T? where T: Decodable {
        let jsonDecoder = JSONDecoder()
        var result: T?
        
        do {
            guard let data = data else {
                return nil
            }
            
            result = try jsonDecoder.decode(modelType, from: data)
        } catch let error {
            print(error)
        }
        
        return result
    }

    // MARK: - Private methods
    private static func serialiFromFile<T>(modelType: T.Type, path: String) -> T? where T: Decodable {
        let url = URL(fileURLWithPath: path)
        var result: T?

        do {
            let data = try Data(contentsOf: url)
            result = serialize(modelType: modelType, data: data)
        } catch let error {
            print("Error: \(error)")
        }

        return result
    }
}
