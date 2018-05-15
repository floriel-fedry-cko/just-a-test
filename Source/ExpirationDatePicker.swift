import UIKit

/// Expiration Date Picker is a control used for the inputting of expiration date
@IBDesignable public class ExpirationDatePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    // Managing the date and calendar
    var calendar: Calendar = Calendar(identifier: .gregorian)
    let timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!

    // Configuring temporal attributes
    var maximumDate: Date = Date(timeIntervalSinceNow: 31556926 * 20)
    let minimumDate: Date = Date()

    /// Delegate
    public weak var pickerDelegate: ExpirationDatePickerDelegate?

    // private properties
    private let months = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    private var years = ["", ""]

    // MARK: - Initialization

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        self.delegate = self
        self.dataSource = self

        #if !TARGET_INTERFACE_BUILDER
        var yearsUsed: [String] = []
        for year in calendar.component(.year, from: minimumDate)...calendar.component(.year, from: maximumDate) {
            yearsUsed.append(String(year))
        }
        years = Array(yearsUsed)
        setDate(minimumDate, animated: false)
        #endif

    }

    // MARK: - UIPickerViewDelegate

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMyyyy"
        let selectedDateString =
        "\(months[pickerView.selectedRow(inComponent: 0)])\(years[pickerView.selectedRow(inComponent: 1)])"
        let selectedDateOpt = formatter.date(from: selectedDateString)

        guard let selectedDate = selectedDateOpt else { return }
        if selectedDate > maximumDate {
            setDate(maximumDate, animated: true)
        }
        if selectedDate < minimumDate {
            setDate(minimumDate, animated: true)
        }
        self.pickerDelegate?.onDateChanged(month: months[pickerView.selectedRow(inComponent: 0)],
                                                   year: years[pickerView.selectedRow(inComponent: 1)])
    }

    // MARK: - UIPickerViewDataSource

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return years[row]
        default:
            return nil
        }
    }

    // MARK: - Methods

    public func setDate(_ date: Date, animated: Bool) {
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)

        let monthIndex = month - 1
        let yearIndex = years.index(of: String(year))

        self.selectRow(monthIndex, inComponent: 0, animated: animated)
        self.selectRow(yearIndex!, inComponent: 1, animated: animated)
    }
}
