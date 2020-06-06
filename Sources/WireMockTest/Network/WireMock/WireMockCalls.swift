//
//  WireMockCalls.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 11/30/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

import Foundation

class WireMockCalls {
    
    // MARK: - Admin API Path
    struct Path {
        static let mappings = "__admin/mappings"
        static let reset = "__admin/reset"
        
        static func mappings(uuid: UUID) -> String {
            return "\(Path.mappings)/\(uuid.uuidString)"
        }
    }
    
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
    private class func getMappingsAsync(success: (([WireMockMapping]) -> Void)?, failure: ((Error?) -> Void)?) {
        sessionManager.get(path: Path.mappings, success: { (responseData) in
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
    
    // MARK: - Get Mapping
    private class func getMappingAsync(uuid: UUID, success: ((WireMockMapping) -> Void)?, failure: ((Error?) -> Void)?) {
        sessionManager.get(path: Path.mappings(uuid: uuid), success: { (responseData) in
            guard let mapping = try? JSONDecoder().decode(WireMockMapping.self, from: responseData) else {
                // TODO - create WireMockError object
                failure?(LocalhostError(type: .parsing))
                return
            }
            
            success?(mapping)
        }, failure: failure)
    }
    
    class func getMapping(uuid: UUID) -> WireMockMapping? {
        var mapping: WireMockMapping?
        
        makeSynchronousCall { (semaphore) in
            getMappingAsync(uuid: uuid, success: { (wireMockMapping) in
                mapping = wireMockMapping
                semaphore.signal()
            }, failure: { (error) in
                if let error = error, configuration.loggingEnabled {
                    print(error.localizedDescription)
                }
                semaphore.signal()
            })
        }
        
        return mapping
    }
    
    // MARK: - Create Mapping
    private class func createMappingAsync(_ mapping: WireMockMapping, success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        let bodyData = try? JSONEncoder().encode(mapping)
        
        sessionManager.post(path: Path.mappings, bodyData: bodyData, success: { (_) in
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
    private class func updateMappingAsync(_ mapping: WireMockMapping, success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        let path = Path.mappings(uuid: mapping.uuid)
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
    private class func resetMappingsAsync(success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        sessionManager.post(path: Path.reset, bodyData: nil, success: { (_) in
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
