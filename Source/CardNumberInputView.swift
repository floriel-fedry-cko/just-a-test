import UIKit

/// Card Number Input View containing a label and an input field.
/// Handles the formatting of the text field.
@IBDesignable public class CardNumberInputView: StandardInputView, UITextFieldDelegate {

    // MARK: - Properties

    var cardsUtils: CardUtils!
    /// Text field delegate
    public weak var delegate: CardNumberInputViewDelegate?

    // MARK: - Initialization

    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    /// Returns an object initialized from data in a given unarchiver.
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        #if !TARGET_INTERFACE_BUILDER
        cardsUtils = CardUtils()
        #endif
        self.textField.keyboardType = .default
        self.textField.textContentType = .creditCardNumber
        self.textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
    }

    // MARK: - UITextFieldDelegate

    /// Asks the delegate if the specified text should be changed.
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {

        // Card Number Formatting
        let cardNumber = cardsUtils!.standardize(cardNumber: "\(textField.text!)\(string)")
        let cardType = cardsUtils.getTypeOf(cardNumber: cardNumber)
        guard let cardTypeUnwrap = cardType else { return true }
        guard cardNumber.count <= cardTypeUnwrap.validLengths.last! else {
            return false
        }
        return true
    }

    @objc public func textFieldDidChange(textField: UITextField) {
        let cardNumber = cardsUtils!.standardize(cardNumber: textField.text!)
        let cardType = cardsUtils.getTypeOf(cardNumber: cardNumber)
        guard let cardTypeUnwrap = cardType else { return }
        delegate?.onChange(cardType: cardType)
        let cardNumberFormatted = cardsUtils.format(cardNumber: cardNumber, cardType: cardTypeUnwrap)
        textField.text = cardNumberFormatted
    }

    /// Tells the delegate that editing stopped for the specified text field.
    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(textField)
    }
}
