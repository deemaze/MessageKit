//
//  MessageWithAttachmentCell.swift
//  
//
//  Created by Bruno Antoninho on 10/03/2023.
//

import UIKit

open class MessageWithAttachmentCell: MessageContentCell {
  
    /// The label used to display the message's text.
    open var messageLabel: MessageLabel = {
      let label = MessageLabel()
      label.numberOfLines = 0
      label.font = UIFont.preferredFont(forTextStyle: .body)

      return label
    }()
    
    open var attachmentContainerView: MessageContainerView = {
      let containerView = MessageContainerView()
      containerView.clipsToBounds = true
      containerView.layer.masksToBounds = true
      return containerView
    }()
    
    // MARK: - Properties

    /// The `MessageCellDelegate` for the cell.
    open override weak var delegate: MessageCellDelegate? {
      didSet {
        messageLabel.delegate = delegate
      }
    }

    // MARK: - Methods

    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
      super.apply(layoutAttributes)
      if let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes {
        messageLabel.textInsets = attributes.messageLabelInsets
        messageLabel.messageLabelFont = attributes.messageLabelFont
        messageLabel.frame = messageContainerView.bounds
      }
    }

    open override func prepareForReuse() {
      super.prepareForReuse()
      messageLabel.attributedText = nil
      messageLabel.text = nil
    }

  // MARK: Open

  open override func setupSubviews() {
      super.setupSubviews()
      messageContainerView.addSubview(messageLabel)
  }
    
    open override func configure(
        with message: MessageType,
        at indexPath: IndexPath,
        and messagesCollectionView: MessagesCollectionView)
    {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }
        
        let enabledDetectors = displayDelegate.enabledDetectors(for: message, at: indexPath, in: messagesCollectionView)
        
        let textMessageKind = message.kind.textMessageKind
        switch textMessageKind {
        case .attachment(let text, let attachments):
            messageLabel.configure {
                messageLabel.enabledDetectors = enabledDetectors
                for detector in enabledDetectors {
                    let attributes = displayDelegate.detectorAttributes(for: detector, and: message, at: indexPath)
                    messageLabel.setAttributes(attributes, detector: detector)
                }
                messageLabel.attributedText = text
                
                for attachment in attachments {
                    let label = MessageLabel()
                    label.attributedText = attachment
                    attachmentContainerView.addSubview(label)
                    contentView.addSubview(attachmentContainerView)
                }
            }
        default:
            break
        }
    }
    
    /// Used to handle the cell's contentView's tap gesture.
    /// Return false when the contentView does not need to handle the gesture.
    open override func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        messageLabel.handleGesture(touchPoint)
    }
}
