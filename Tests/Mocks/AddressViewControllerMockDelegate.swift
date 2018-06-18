import Foundation
@testable import CheckoutSdkIos

class AddressViewControllerMockDelegate: AddressViewControllerDelegate {

    var onTapDoneButtonCalledTimes = 0
    var onTapDoneButtonLastCalledWith: CkoAddress?

    func onTapDoneButton(address: CkoAddress) {
        onTapDoneButtonCalledTimes += 1
        onTapDoneButtonLastCalledWith = address
    }
}
