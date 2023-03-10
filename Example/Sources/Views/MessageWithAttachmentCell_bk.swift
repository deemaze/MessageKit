//
//  MessageWithAttachmentCell.swift
//  ChatExample
//
//  Created by Bruno Antoninho on 10/03/2023.
//  Copyright © 2023 MessageKit. All rights reserved.
//

import MessageKit
import UIKit

class MessageWithAttachmentCell_bk: MessageCollectionViewCell {
  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    setupSubviews()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    setupSubviews()
  }

  // MARK: Internal

  /// The `MessageCellDelegate` for the cell.
  weak var delegate: MessageCellDelegate?

  /// The container used for styling and holding the message's content view.
  var messageContainerView: UIView = {
    let containerView = UIView()
    containerView.clipsToBounds = true
    containerView.layer.masksToBounds = true
    return containerView
  }()

  /// The top label of the cell.
  var cellTopLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()

  var cellDateLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .right
    return label
  }()
    
    /// The container used for holding the message's attachmment content view.
    var messageAttachmentContainerView: UIView = {
      let containerView = UIView()
      containerView.clipsToBounds = true
      containerView.layer.masksToBounds = true
      return containerView
    }()

  override func prepareForReuse() {
    super.prepareForReuse()
    cellTopLabel.text = nil
    cellTopLabel.attributedText = nil
    cellDateLabel.text = nil
    cellDateLabel.attributedText = nil
  }

  /// Handle tap gesture on contentView and its subviews.
  override func handleTapGesture(_ gesture: UIGestureRecognizer) {
    let touchLocation = gesture.location(in: self)

    switch true {
    case messageContainerView.frame
      .contains(touchLocation) && !cellContentView(canHandle: convert(touchLocation, to: messageContainerView)):
      delegate?.didTapMessage(in: self)
    case cellTopLabel.frame.contains(touchLocation):
      delegate?.didTapCellTopLabel(in: self)
    case cellDateLabel.frame.contains(touchLocation):
      delegate?.didTapMessageBottomLabel(in: self)
    default:
      delegate?.didTapBackground(in: self)
    }
  }

  /// Handle long press gesture, return true when gestureRecognizer's touch point in `messageContainerView`'s frame
  override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    let touchPoint = gestureRecognizer.location(in: self)
    guard gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) else { return false }
    return messageContainerView.frame.contains(touchPoint)
  }

  func setupSubviews() {
    messageContainerView.layer.cornerRadius = 5

    contentView.addSubview(cellTopLabel)
    contentView.addSubview(messageContainerView)
    messageContainerView.addSubview(cellDateLabel)
  }

  func configure(
    with message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView,
    dataSource: MessagesDataSource,
    and sizeCalculator: CustomLayoutSizeCalculator)
  {
    guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
      return
    }
    cellTopLabel.frame = sizeCalculator.cellTopLabelFrame(
      for: message,
      at: indexPath)
    cellDateLabel.frame = sizeCalculator.cellMessageBottomLabelFrame(
      for: message,
      at: indexPath)
    messageContainerView.frame = sizeCalculator.messageContainerFrame(
      for: message,
      at: indexPath,
      fromCurrentSender: dataSource
        .isFromCurrentSender(message: message))
    cellTopLabel.attributedText = dataSource.cellTopLabelAttributedText(
      for: message,
      at: indexPath)
    cellDateLabel.attributedText = dataSource.messageBottomLabelAttributedText(
      for: message,
      at: indexPath)
    messageContainerView.backgroundColor = displayDelegate.backgroundColor(
      for: message,
      at: indexPath,
      in: messagesCollectionView)
  }

  /// Handle `ContentView`'s tap gesture, return false when `ContentView` doesn't needs to handle gesture
  func cellContentView(canHandle _: CGPoint) -> Bool {
    false
  }
}
