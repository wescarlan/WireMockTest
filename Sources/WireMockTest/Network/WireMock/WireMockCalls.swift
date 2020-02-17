//
//  WireMockCalls.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 11/30/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

import Foundation

class WireMockCalls {
    
    // MARK: - Session Configuration
    private class var sessionManager: LocalhostSessionManager {
        return LocalhostSessionManager.shared
    }
    
    private class var configuration: WireMockConfiguration {
        return WireMockTest.configuration
    }
    
    // MARK: - Initialize session
    private class func initializeSessionAsync(success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        resetMappingsAsync(success: {
            getMappingsAsync(success: { (_) in
                success?()
            }, failure: failure)
        }, failure: failure)
    }
    
    class func initializeSession() -> Error? {
        var error: Error?
        
        makeSynchronousCall { (semaphore) in
            initializeSessionAsync(success: {
                semaphore.signal()
            }, failure: { (initializationError) in
                if let initializationError = initializationError, configuration.loggingEnabled {
                    print(initializationError.localizedDescription)
                }
                error = initializationError
                semaphore.signal()
            })
        }
        
        return error
    }
    
    // MARK: - Get Mappings
    private static let mappingsPath = "__admin/mappings"
    
    private class func getMappingsAsync(success: (([WireMockMapping]) -> Void)?, failure: ((Error?) -> Void)?) {
        sessionManager.get(path: mappingsPath, success: { (responseData) in
            guard let mappingResponse = try? JSONDecoder().decode(GetMappingsResponse.self, from: responseData) else {
                // TODO - create WireMockError object
                failure?(LocalhostError(type: .parsing))
                return
            }
            
            success?(mappingResponse.mappings)
        }, failure: failure)
    }
    
    class func getMappings() -> [WireMockMapping] {
        var mappings: [WireMockMapping] = []
        
        makeSynchronousCall { (semaphore) in
            getMappingsAsync(success: { (wireMockMappings) in
                mappings = wireMockMappings
                semaphore.signal()
            }, failure: { (error) in
                if let error = error, configuration.loggingEnabled {
                    print(error.localizedDescription)
                }
                semaphore.signal()
            })
        }
        
        return mappings
    }
    
    // MARK: - Create Mapping
    private class func createMappingAsync(_ mapping: WireMockMapping, success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        let bodyData = try? JSONEncoder().encode(mapping)
        
        sessionManager.post(path: mappingsPath, bodyData: bodyData, success: { (_) in
            success?()
        }, failure: failure)
    }
    
    class func createMapping(_ mapping: WireMockMapping) {
        makeSynchronousCall { (semaphore) in
            createMappingAsync(mapping, success: {
                semaphore.signal()
            }, failure: { (error) in
                if let error = error, configuration.loggingEnabled {
                    print(error.localizedDescription)
                }
                semaphore.signal()
            })
        }
    }
    
    // MARK: - Update Mapping
    private class func updateMappingPath(uuid: UUID) -> String {
        return "\(mappingsPath)/\(uuid.uuidString)"
    }
    
    private class func updateMappingAsync(_ mapping: WireMockMapping, success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        let path = updateMappingPath(uuid: mapping.uuid)
        let bodyData = try? JSONEncoder().encode(mapping)
        
        sessionManager.put(path: path, bodyData: bodyData, success: { (_) in
            success?()
        }, failure: failure)
    }
    
    class func updateMapping(_ mapping: WireMockMapping) {
        makeSynchronousCall { (semaphore) in
            updateMappingAsync(mapping, success: {
                semaphore.signal()
            }, failure: { (error) in
                if let error = error, configuration.loggingEnabled {
                    print(error.localizedDescription)
                }
                semaphore.signal()
            })
        }
    }
    
    // MARK: - Reset Mappings
    private static let resetMappingsPath = "__admin/reset"
    
    private class func resetMappingsAsync(success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        sessionManager.post(path: resetMappingsPath, bodyData: nil, success: { (_) in
            success?()
        }, failure: failure)
    }
    
    class func resetMappings() {
        makeSynchronousCall { (semaphore) in
            resetMappingsAsync(success: {
                semaphore.signal()
            }, failure: { (error) in
                if let error = error, configuration.loggingEnabled {
                    print(error.localizedDescription)
                }
                semaphore.signal()
            })
        }
    }
    
    // MARK: - Synchronization
    private static let synchronizedWaitTimeout: TimeInterval = 5.0
    
    private class func makeSynchronousCall(call: (DispatchSemaphore) -> Void) {
        let semaphore = DispatchSemaphore(value: 0)
        call(semaphore)
        let _ = semaphore.wait(timeout: .now() + synchronizedWaitTimeout)
    }
}
