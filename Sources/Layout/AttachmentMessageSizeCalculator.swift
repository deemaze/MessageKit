//
//  AttachmentMessageSizeCalculator.swift
//  
//
//  Created by Bruno Antoninho on 11/03/2023.
//

import UIKit

open class AttachmentMessageSizeCalculator: CellSizeCalculator {
  // MARK: Lifecycle

  public init(layout: MessagesCollectionViewFlowLayout? = nil) {
    super.init()
    self.layout = layout
  }

  // MARK: Open

//  open override func sizeForItem(at _: IndexPath) -> CGSize {
//    guard let layout = layout as? MessagesCollectionViewFlowLayout else { return .zero }
//      
//      return layout.messagesLayoutDelegate.attachmentTextCellSizeCalculator(for: <#T##MessageType#>, at: <#T##IndexPath#>, in: <#T##MessagesCollectionView#>)
//      
//    return layout.messagesLayoutDelegate.typingIndicatorViewSize(for: layout)
//  }
}
