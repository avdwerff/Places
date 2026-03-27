//
//  CustomLocationViewModeling.swift
//  Places
//
//  Created by Alexander van der Werff on 27/03/2026.
//

import Observation

protocol CustomLocationViewModeling: Observable {
    var latitude: String { get set }
    var longitude: String { get set }
    var didFailToOpen: Bool { get set }
    var isValid: Bool { get }
    
    func openInWikipedia() async
}
