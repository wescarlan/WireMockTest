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
    
    // MARK: - Properties
    private let configuration: WireMockConfiguration
    private let sessionManager: LocalhostSessionManager
    
    
    // MARK: - Initializer
    init(configuration: WireMockConfiguration) {
        self.configuration = configuration
        self.sessionManager = LocalhostSessionManager(configuration: LocalhostConfiguration(configuration))
    }
    
    // MARK: - Initialize session
    private func initializeSessionAsync(success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        resetMappingsAsync(success: { [weak self] in
            guard let self = self else { return }
            self.getMappingsAsync(success: { (_) in
                success?()
            }, failure: failure)
        }, failure: failure)
    }
    
    func initializeSession() -> Error? {
        var error: Error?
        
        makeSynchronousCall { (semaphore) in
            initializeSessionAsync(success: {
                semaphore.signal()
            }, failure: { (initializationError) in
                error = initializationError
                WireMockCalls.logError(error: error)
                semaphore.signal()
            })
        }
        
        return error
    }
    
    // MARK: - Get Mappings
    private func getMappingsAsync(success: (([WireMockMapping<String>]) -> Void)?, failure: ((Error?) -> Void)?) {
        sessionManager.get(path: Path.mappings, success: { (responseData) in
            guard let mappingResponse = try? JSONDecoder().decode(GetMappingsResponse.self, from: responseData) else {
                // TODO - create WireMockError object
                failure?(LocalhostError.parsing)
                return
            }
            
            success?(mappingResponse.mappings)
        }, failure: failure)
    }
    
    func getMappings() -> [WireMockMapping<String>] {
        var mappings: [WireMockMapping<String>] = []
        
        makeSynchronousCall { (semaphore) in
            getMappingsAsync(success: { (wireMockMappings) in
                mappings = wireMockMappings
                semaphore.signal()
            }, failure: { (error) in
                WireMockCalls.logError(error: error)
                semaphore.signal()
            })
        }
        
        return mappings
    }
    
    // MARK: - Get Mapping
    private func getMappingAsync<T: Codable>(uuid: UUID, responseType: T.Type, success: ((WireMockMapping<T>) -> Void)?, failure: ((Error?) -> Void)?) {
        sessionManager.get(path: Path.mappings(uuid: uuid), success: { (responseData) in
            guard let mapping = try? JSONDecoder().decode(WireMockMapping<T>.self, from: responseData) else {
                // TODO - create WireMockError object
                failure?(LocalhostError.parsing)
                return
            }
            
            success?(mapping)
        }, failure: failure)
    }
    
    func getMapping<T: Codable>(uuid: UUID, responseType: T.Type) -> WireMockMapping<T>? {
        var mapping: WireMockMapping<T>?
        
        makeSynchronousCall { (semaphore) in
            getMappingAsync(uuid: uuid, responseType: responseType, success: { (wireMockMapping) in
                mapping = wireMockMapping
                semaphore.signal()
            }, failure: { (error) in
                WireMockCalls.logError(error: error)
                semaphore.signal()
            })
        }
        
        return mapping
    }
    
    // MARK: - Create Mapping
    private func createMappingAsync<T: Codable>(_ mapping: WireMockMapping<T>, success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        let bodyData = try? JSONEncoder().encode(mapping)
        
        sessionManager.post(path: Path.mappings, bodyData: bodyData, success: { (_) in
            success?()
        }, failure: failure)
    }
    
    func createMapping<T: Codable>(_ mapping: WireMockMapping<T>) {
        makeSynchronousCall { (semaphore) in
            createMappingAsync(mapping, success: {
                semaphore.signal()
            }, failure: { (error) in
                WireMockCalls.logError(error: error)
                semaphore.signal()
            })
        }
    }
    
    // MARK: - Update Mapping
    private func updateMappingAsync<T: Codable>(_ mapping: WireMockMapping<T>, success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        let path = Path.mappings(uuid: mapping.uuid)
        let bodyData = try? JSONEncoder().encode(mapping)
        
        sessionManager.put(path: path, bodyData: bodyData, success: { (_) in
            success?()
        }, failure: failure)
    }
    
    func updateMapping<T: Codable>(_ mapping: WireMockMapping<T>) {
        makeSynchronousCall { (semaphore) in
            updateMappingAsync(mapping, success: {
                semaphore.signal()
            }, failure: { (error) in
                WireMockCalls.logError(error: error)
                semaphore.signal()
            })
        }
    }
    
    // MARK: - Reset Mappings
    private func resetMappingsAsync(success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        sessionManager.post(path: Path.reset, bodyData: nil, success: { (_) in
            success?()
        }, failure: failure)
    }
    
    func resetMappings() {
        makeSynchronousCall { (semaphore) in
            resetMappingsAsync(success: {
                semaphore.signal()
            }, failure: { (error) in
                WireMockCalls.logError(error: error)
                semaphore.signal()
            })
        }
    }
    
    // MARK: - Synchronization
    private let synchronizedWaitTimeout: TimeInterval = 5.0
    
    private func makeSynchronousCall(call: (DispatchSemaphore) -> Void) {
        let semaphore = DispatchSemaphore(value: 0)
        call(semaphore)
        let _ = semaphore.wait(timeout: .now() + synchronizedWaitTimeout)
    }
    
    // MARK: - Error Logging
    private class func logError(error: Error?) {
        guard let error = error, WireMockTest.loggingEnabled else { return }
        
        if let error = error as? LocalhostError {
            print(error.localizedDescription)
        } else {
            print(error.localizedDescription)
        }
    }
}
