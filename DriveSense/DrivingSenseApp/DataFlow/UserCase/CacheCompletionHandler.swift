//
//  CacheCompletionHandler.swift
//  DriveSense
//
//  Created by Arpit Singh on 20/09/22.
//

import Foundation
protocol CachingCompletionHandler {
    func cachingFinished(WithError: Error)
    func cachingFinished<T : Equatable>(res: T?)
}
