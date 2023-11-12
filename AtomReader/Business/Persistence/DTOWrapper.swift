//
//  DTOWrapper.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-11.
//

import Foundation

protocol DTOWrapper {
    associatedtype Wrapped: DTOWrapped where Wrapped.Wrapper == Self
    
    init(from wrapped: Wrapped)
}

protocol DTOWrapped {
    associatedtype Wrapper: DTOWrapper where Wrapper.Wrapped == Self
    
    init(from wrapper: Wrapper)
}
