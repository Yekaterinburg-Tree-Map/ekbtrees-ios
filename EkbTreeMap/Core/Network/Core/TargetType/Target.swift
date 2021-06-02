//
//  TargetTypeProtocol.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import Moya


protocol Target: TargetType {
    
}

protocol AuthorizedTarget: AccessTokenAuthorizable, Target {
    
}
