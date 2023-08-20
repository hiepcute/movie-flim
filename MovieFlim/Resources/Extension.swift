//
//  Extension.swift
//  MovieFlim
//
//  Created by MACBOOK on 14/08/2023.
//

import Foundation


extension String {
    func UpperCaseFirstLetter()  -> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
        
    }
}
