//
//  CacheCompletionHandler.swift
//  DriveSense
//
//  Created by Arpit Singh on 20/09/22.
//

import Foundation
protocol CachingCompletionHandler: AnyObject {
    func cachingFinished(withError: Error)
    func cachingFinished<T : Equatable>(res: T?)
}
