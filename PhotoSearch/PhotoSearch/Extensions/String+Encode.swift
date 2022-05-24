//
//  String+Encode.swift
//  PhotoSearch
//
//  Created by bnulo on 5/24/22.
//

import Foundation

extension String {
  func encodeURL() -> String? {
    let allowedCharacters = CharacterSet.alphanumerics
          .union(.init(charactersIn: "-._~"))
    return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
  }
}
