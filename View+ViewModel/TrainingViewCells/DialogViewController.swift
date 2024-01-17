import Combine
import UIKit
import Foundation

protocol DialogViewDelegate {
    func onCheckboxPickerValueChanged(_ trainingType: String, _ time: String, day: (name: String, index:Int))
}

 class DialogViewController: UIViewController {
    let dialogViewWidth: CGFloat = 300.0
    var dialogViewHeight: CGFloat = 462.0

     private var cancellableSet: Set<AnyCancellable> = []
    var sections = TrainingAPI.getTraining()
     let trainingString = ["Select training","KMG", "Wrestling", "Bjj", "KickBox", "MMA", "Box"]
    var dialogView: UIView!
    let titleView = UIView()
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    lazy var training = UITextField()
    lazy var selectDayButton = UIButton()
    lazy var time = UIButton()
    let cancelButton = UIButton()
    let saveButton = UIButton()
    let defaultActionsStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let buttonOptionsStackView = UIStackView()
    var dialogHeightConstraint: NSLayoutConstraint?

    var delegateDialogViews: DialogViewDelegate?
    // properties exposed to developer/user
    var titleDialog: String = ""
   @Published var trainingIsValid = false
   @Published var dayIsValid = false

     var readyToSubmit: AnyPublisher<Bool, Never> {
         return Publishers.CombineLatest($trainingIsValid, $dayIsValid)
             .map { value2, value1 in
                 let realValue = (value1 && value2)
                 return realValue
             }
             .eraseToAnyPublisher()
     }

    let picker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
    let timeStackView = UIStackView()

    override open func viewDidLoad() {
        print("\(type(of: self)) did load")
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // color to represent dialog as modal view

        showDialogView()

        readyToSubmit
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: saveButton)
            .store(in: &cancellableSet)
    }

    @objc func saveButtonAction(_ sender: UIButton!) {
        // on OK pressed we need to set selectedValues
        self.dismiss(animated: false, completion: nil)
        self.delegateDialogViews?.onCheckboxPickerValueChanged((self.training.text)!, picker.date.formatted().components(separatedBy: ", ")[1], day: (name: selectDayButton.currentTitle!, index: selectDayButton.tag))
    }

    @objc func cancelButtonAction(_ sender: UIButton!) {
        self.dismiss(animated: false, completion: nil)
    }

    func showDialogView() {
        createDialogView()
        createTitleView()
        createTitleLabel()
        setupOptionButtonsStackView()
        createCancelButton()
        createSaveButton()
        createDefaultActionsStackView()
        // self.view.layoutIfNeeded()
    }

    func createDialogView() {
        dialogView = UIView()
        dialogView.layer.borderWidth = 1
        dialogView.layer.borderColor = UIColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1).cgColor
        dialogView.layer.cornerRadius = 8.0
        dialogView.clipsToBounds = true
        dialogView.backgroundColor = UIColor.white

        dialogView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(dialogView)

        dialogView.widthAnchor.constraint(equalToConstant: dialogViewWidth).isActive = true
        //dialogView.heightAnchor.constraint(equalToConstant: dialogViewHeight).isActive = true
        dialogView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dialogView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func createTitleView() {
        titleView.backgroundColor = UIColor.white

        titleView.translatesAutoresizingMaskIntoConstraints = false
        self.dialogView.addSubview(titleView)

        titleView.widthAnchor.constraint(equalToConstant: dialogViewWidth).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        titleView.centerXAnchor.constraint(equalTo: self.dialogView.centerXAnchor).isActive = true
        titleView.topAnchor.constraint(equalTo: self.dialogView.topAnchor).isActive = true
    }

    func createTitleLabel() {
        let title = titleDialog
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        titleLabel.text = title
        titleLabel.textColor = UIColor(red: 0.0, green: 123 / 255, blue: 1.0, alpha: 1)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleView.addSubview(titleLabel)

        titleLabel.widthAnchor.constraint(equalToConstant: dialogViewWidth - 10).isActive = true // 10 is for padding, 5 on each side since we have centerX
        titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    }

    func trainingButton() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self

        training.inputView = pickerView
        training.textAlignment = .center
        training.text = "Training"
        training.font = .systemFont(ofSize: 18, weight: .regular)
        training.layer.cornerRadius = 10
        training.textColor = .gray
        training.backgroundColor = UIColor.systemGray6
//
//        let trainings = ["KMG", "Wrestling", "Bjj", "KickBox", "MMA", "Box"]
//        let actions = trainings.map { training in
//            UIAction(title: training) { [weak self] _ in
//                self?.training.setTitle(training, for: .normal)
//                self?.training.tintColor = .darkText
//            }
//        }
//        let menu = UIMenu(title: "Select training", options: .singleSelection, children: actions)
//
//        training = UIButton(configuration: .plain())
//        training.backgroundColor = UIColor.systemGray6
//        training.layer.cornerRadius = 10
//        training.showsMenuAsPrimaryAction = true
//        training.menu = menu
//        training.setTitle("Training", for: .normal)
//        training.tintColor = .gray

        training.translatesAutoresizingMaskIntoConstraints = false

        self.buttonOptionsStackView.addArrangedSubview(training)
    }

    func setupOptionButtonsStackView() {

        self.dialogView.addSubview(buttonOptionsStackView)
        buttonOptionsStackView.translatesAutoresizingMaskIntoConstraints = false

        buttonOptionsStackView.topAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        buttonOptionsStackView.centerXAnchor.constraint(equalTo: dialogView.centerXAnchor).isActive = true
        buttonOptionsStackView.axis = .vertical
        buttonOptionsStackView.alignment = .center
        buttonOptionsStackView.distribution = .fillEqually
        buttonOptionsStackView.spacing = 20

        trainingButton()
        timeButton()
        createSelectDayButton()

        buttonOptionsStackView.subviews.forEach { $0.widthAnchor.constraint(equalTo: dialogView.widthAnchor, multiplier: 0.6).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true }
    }

    func timeButton() {

        time = UIButton(configuration: .plain())
        time.setTitle("Time", for: .normal)
        time.setTitleColor(.gray, for: .normal)
        picker.autoresizingMask = .flexibleHeight
        picker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .inline


        timeStackView.translatesAutoresizingMaskIntoConstraints = false


        timeStackView.axis = .horizontal
        timeStackView.alignment = .center
        timeStackView.distribution = .fillEqually
        timeStackView.backgroundColor = UIColor.systemGray6
        timeStackView.layer.cornerRadius = 10
        timeStackView.clipsToBounds = true


        self.buttonOptionsStackView.addArrangedSubview(timeStackView)
        self.timeStackView.addArrangedSubview(time)
        self.timeStackView.addArrangedSubview(picker)
    }

    func createSelectDayButton() {
        // 1
        let actions = sections.map { weekdays in
            UIAction(title: weekdays.weekDay.description) { [weak self] _ in
                self?.selectDayButton.setTitle(weekdays.weekDay.description, for: .normal)
                self?.selectDayButton.tag = weekdays.weekDay.rawValue
                self?.selectDayButton.tintColor = .darkText
                self?.dayIsValid = true
            }
        }
        // 2 This is where the divider comes from. You need a UIMenu using the .displayInline option. Then, just pass in its children.
        let menu = UIMenu(title: "Select day", options: .singleSelection, children: actions)

        selectDayButton = UIButton(configuration: .plain())
        selectDayButton.backgroundColor = UIColor.systemGray6
        selectDayButton.tintColor = .gray
        selectDayButton.layer.cornerRadius = 10
        selectDayButton.setTitle("Day", for: .normal)
        selectDayButton.showsMenuAsPrimaryAction = true
        selectDayButton.menu = menu

        self.buttonOptionsStackView.addArrangedSubview(selectDayButton)
    }

    func createCancelButton() {
        cancelButton.backgroundColor = UIColor.white
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.opaqueSeparator.cgColor
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        cancelButton.setTitle("Cancel", for: UIControl.State.normal)
        cancelButton.setTitleColor(UIColor.systemBlue, for: UIControl.State())
        cancelButton.widthAnchor.constraint(equalToConstant: dialogViewWidth / 2).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func createSaveButton() {
        saveButton.configuration = .plain()
        saveButton.backgroundColor = UIColor.white
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.opaqueSeparator.cgColor
        saveButton.setTitle("Save", for: UIControl.State.normal)

        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        saveButton.setTitleColor(UIColor.systemBlue, for: .normal)
        saveButton.widthAnchor.constraint(equalToConstant: dialogViewWidth / 2).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func createDefaultActionsStackView() {
        defaultActionsStackView.backgroundColor = UIColor.white
        defaultActionsStackView.axis = NSLayoutConstraint.Axis.horizontal
        defaultActionsStackView.distribution = UIStackView.Distribution.equalSpacing
        defaultActionsStackView.alignment = UIStackView.Alignment.center
        defaultActionsStackView.spacing   = 0.0

        defaultActionsStackView.addArrangedSubview(cancelButton)
        defaultActionsStackView.addArrangedSubview(saveButton)
        defaultActionsStackView.translatesAutoresizingMaskIntoConstraints = false
        self.dialogView.addSubview(defaultActionsStackView)

        defaultActionsStackView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        defaultActionsStackView.leadingAnchor.constraint(equalTo: self.dialogView.leadingAnchor).isActive = true
        defaultActionsStackView.trailingAnchor.constraint(equalTo: self.dialogView.trailingAnchor).isActive = true

        // vartical spacing to tableView
        defaultActionsStackView.topAnchor.constraint(equalTo: self.buttonOptionsStackView.bottomAnchor, constant: 20).isActive = true
        defaultActionsStackView.bottomAnchor.constraint(equalTo: self.dialogView.bottomAnchor).isActive = true
    }

    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        resizeDialogView()
    }

    func resizeDialogView() {
        // remove constraints before applying new one
        removeDialogViewHeightConstraint()

        dialogViewHeight = calculateDialogViewHeight()
        let height = UIScreen.main.bounds.height
        if height < dialogViewHeight {
            dialogViewHeight = height - 40 // device screen height - arbitrary value so dialog doesn't take full screen height
        }

        // apply new constraints
        addDialogViewHeightConstraint()
    }

    func addDialogViewHeightConstraint() {
        dialogHeightConstraint = dialogView.heightAnchor.constraint(equalToConstant: dialogViewHeight)
        dialogHeightConstraint?.isActive = false
    }

    func removeDialogViewHeightConstraint() {
        if dialogHeightConstraint != nil {
            dialogHeightConstraint?.isActive = false
            dialogView.removeConstraint(dialogHeightConstraint!)
        }
    }

    func calculateDialogViewHeight() -> CGFloat {
        // cell height * number of cells + 3 more cell heights so we have enough space for title and buttons
        return 212   }
}

extension DialogViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        trainingString.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        trainingString[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0 {
            training.text = trainingString[row]
            training.textColor = .darkText
            trainingIsValid = true
        }
        self.view.endEditing(true)
    }

}
