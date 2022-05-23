
import DropDown
import UIKit
import Foundation



 protocol DialogViewDelegate{
    func onCheckboxPickerValueChanged(_ trainingType: String, _ time: String) 
}

open class DialogViewController: UIViewController {
    let dialogViewWidth: CGFloat = 300.0
     var dialogViewHeight: CGFloat = 462.0
    
     var dialogView: UIView!
     let titleView = UIView()
     let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
     let training = UIButton()
     let time = UITextField()
     let cancelButton = UIButton()
     let okButton = UIButton()
     let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
     var dialogHeightConstraint: NSLayoutConstraint?
    
     var delegateDialogViews: DialogViewDelegate?
    //properties exposed to developer/user
     var titleDialog: String = ""

    let dropDown = DropDown()
    let picker = UIDatePicker()

    override open func viewDidLoad() {
        print("\(type(of: self)) did load")
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // color to represent dialog as modal view
        
       
        showDialogView()
    }
    
    @objc func okButtonAction(_ sender: UIButton!) {
        // on OK pressed we need to set selectedValues
        self.dismiss(animated: false, completion: nil)
        self.delegateDialogViews?.onCheckboxPickerValueChanged((self.training.titleLabel?.text)!, time.text!)
       
    }
    
    @objc func cancelButtonAction(_ sender: UIButton!) {
      
        self.dismiss(animated: false, completion: nil)
    }
    
    func showDialogView() {
        createDialogView()
        createTitleView()
        createTitleLabel()
        trainingButton()
        timeButton()
        createCancelButton()
        createOkButton()
        createStackView()
        //self.view.layoutIfNeeded()
    }
    
    func createDialogView() {
        dialogView = UIView()
        dialogView.layer.borderWidth = 1
        dialogView.layer.borderColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1).cgColor
        dialogView.layer.cornerRadius = 8.0
        dialogView.clipsToBounds = true
        dialogView.backgroundColor = UIColor.white
        
        dialogView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(dialogView)
        
        dialogView.widthAnchor.constraint(equalToConstant: dialogViewWidth).isActive = true
        dialogView.heightAnchor.constraint(equalToConstant: dialogViewHeight).isActive = true
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
        titleLabel.textColor =  UIColor(red: 0.0, green: 123/255, blue: 1.0, alpha: 1)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleView.addSubview(titleLabel)
        
        titleLabel.widthAnchor.constraint(equalToConstant: dialogViewWidth-10).isActive = true // 10 is for padding, 5 on each side since we have centerX
        titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    }
    
    func trainingButton(){
        training.backgroundColor = UIColor.purple
        training.layer.cornerRadius = 10
        training.addTarget(self, action: #selector(trainingAdded), for: .touchUpInside)
        training.translatesAutoresizingMaskIntoConstraints = false
        self.dialogView.addSubview(training)
        training.setTitle("Training type", for: .normal)
        
        training.widthAnchor.constraint(equalToConstant: 180.0).isActive = true
        training.heightAnchor.constraint(equalToConstant: 40).isActive = true
        training.centerXAnchor.constraint(equalTo: self.dialogView.centerXAnchor).isActive = true
        training.topAnchor.constraint(equalTo: self.titleView.bottomAnchor).isActive = true
        
    }
    func timeButton(){
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTapped))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelTapped))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([doneBtn,flexible,cancelBtn], animated: true)
        time.placeholder = "Choose time"
        time.layer.cornerRadius = 10
        picker.translatesAutoresizingMaskIntoConstraints = false
        //view.addSubview(picker)
//        let constraints = [
//           //picker.heightAnchor.constraint(equalToConstant: 32.0),
//            picker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32.0),
//            picker.topAnchor.constraint(equalTo: dialogView.bottomAnchor, constant: 8.0),
//           picker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32.0)
//        ]
        //NSLayoutConstraint.activate(constraints)
        
        picker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        picker.datePickerMode = .time
        
        picker.contentHorizontalAlignment = .center
        picker.contentVerticalAlignment = .center
        time.inputAccessoryView = toolbar
        time.inputView = picker
        time.textAlignment = .center
        time.translatesAutoresizingMaskIntoConstraints = false
        self.dialogView.addSubview(time)
        
       
        time.widthAnchor.constraint(equalToConstant: 180.0).isActive = true
        time.centerXAnchor.constraint(equalTo: self.dialogView.centerXAnchor).isActive = true
        time.topAnchor.constraint(equalTo: self.training.bottomAnchor,constant: 30).isActive = true
        time.heightAnchor.constraint(equalToConstant: 40).isActive = true
        time.backgroundColor = .brown
        
    }
    
    func createCancelButton() {
        cancelButton.backgroundColor   = UIColor.white
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        cancelButton.setTitle("Cancel", for: UIControl.State.normal)
        cancelButton.setTitleColor(UIColor(red: 0.0, green: 123/255, blue: 1.0, alpha: 1), for: UIControl.State())
        cancelButton.widthAnchor.constraint(equalToConstant: dialogViewWidth / 2).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    }
    
    func createOkButton() {
        okButton.backgroundColor   = UIColor.white
        okButton.layer.borderWidth = 1
        okButton.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        okButton.setTitle("OK", for: UIControl.State.normal)
        okButton.addTarget(self, action: #selector(okButtonAction), for: .touchUpInside)
        okButton.setTitleColor(UIColor(red: 0.0, green: 123/255, blue: 1.0, alpha: 1), for: UIControl.State())
        okButton.widthAnchor.constraint(equalToConstant: dialogViewWidth / 2).isActive = true
        okButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    }
    
    func createStackView() {
        stackView.backgroundColor = UIColor.white
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 0.0
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(okButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.dialogView.addSubview(stackView)
        
        stackView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.dialogView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.dialogView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.dialogView.bottomAnchor).isActive = true
        
        // vartical spacing to tableView
        stackView.topAnchor.constraint(equalTo: self.time.bottomAnchor,constant: 20).isActive = true
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
        dialogHeightConstraint?.isActive = true
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
    
    @objc func trainingAdded(_ sender: UIButton){
        
        dropDown.dataSource = ["KMG","Wrestling","Bjj","KickBox","MMA","Box"]
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
              sender.setTitle(item, for: .normal)
        
    }
   
}
    @objc func doneTapped(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        time.text = formatter.string(from: picker.date)
        time.textColor = .link
        self.view.endEditing(true)
    }
    @objc func cancelTapped(){
        self.view.endEditing(true)
    }
}

