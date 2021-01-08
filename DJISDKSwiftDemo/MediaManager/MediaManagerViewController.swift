//
//  MediaManagerViewController.swift
//  DJISDKSwiftDemo
//
//  Created by Macbook on 28/12/2020.
//  Copyright © 2020 DJI. All rights reserved.
//

import UIKit
import DJISDK

class MediaManagerViewController: UIViewController , DJICameraDelegate, DJIMediaManagerDelegate, UITextFieldDelegate{
    
    
    var mediaManager: DJIMediaManager?
    var mediaList: [AnyHashable]?
    var selectedCellIndexPath: IndexPath?
    
    // Processing on Media variables
    var statusAlertView: DJIAlertView?
    var selectedMedia: DJIMediaFile?
    var previousOffset = 0
    var fileData: Data?
    
    @IBOutlet private weak var positionTextField: UITextField!
    @IBOutlet private weak var mediaTableView: UITableView!
    @IBOutlet private weak var videoPreviewView: UIView!
    @IBOutlet private weak var editBtn: UIButton!
    @IBOutlet private weak var deleteBtn: UIButton!
    @IBOutlet private weak var cancelBtn: UIButton!
    @IBOutlet private weak var reloadBtn: UIButton!
    @IBOutlet private weak var displayImageView: UIImageView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        positionTextField.delegate = self
        initData()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let camera = DemoUtility.fetchCamera()
        if let camera = camera {
            
            camera.delegate = self
            mediaManager = camera.mediaManager
            mediaManager?.delegate = self
            camera.setMode(DJICameraMode.mediaDownload, withCompletion: { error in
                if let error = error {
                    print("setMode failed: \(error.localizedDescription)")
                }
            })
            self.loadMediaList();
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let camera = DemoUtility.fetchCamera()
        camera?.setMode(DJICameraMode.shootPhoto, withCompletion: { error in
            if let error = error {
                print("Set CameraWorkModeShootPhoto Failed, %@", error.localizedDescription)
            }
        })

        if camera != nil  {    // && camera?.delegate == self
            camera?.delegate = nil
            mediaManager?.delegate = nil
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func prefersStatusBarHidden() -> Bool {
        return false
    }
    // MARK: - Custom Methods
    func initData() {
        //deleteBtn.isEnabled = false
        cancelBtn.isEnabled = false
        reloadBtn.isEnabled = false
        editBtn.isEnabled = false
        mediaList = [AnyHashable]()
        fileData = nil
        selectedMedia = nil
        previousOffset = 0
        print("Will have to Comment Back these lines")
        //statusView = DJIScrollView(viewController: self)
        //statusView.isHidden = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func editBtnAction(_ sender: Any) {
        mediaTableView.setEditing(true, animated: true)
        deleteBtn.isEnabled = true
        cancelBtn.isEnabled = true
        editBtn.isEnabled = false
    }

    @IBAction func cancelBtnAction(_ sender: Any) {
        mediaTableView.setEditing(false, animated: true)
        editBtn.isEnabled = true
        deleteBtn.isEnabled = false
        cancelBtn.isEnabled = false
    }

    @IBAction func reloadBtnAction(_ sender: Any) {
    }

    @IBAction func statusBtnAction(_ sender: Any) {
    }

    @IBAction func downloadBtnAction(_ sender: Any) {
        print("Downloading Media")
        let isPhoto = selectedMedia?.mediaType == DJIMediaType.JPEG || selectedMedia?.mediaType == DJIMediaType.TIFF
       // WeakRef(target)
        if statusAlertView == nil {
            let message = "Fetch Media Data \n 0.0"
            statusAlertView = DJIAlertView.show(withMessage: message, titles: ["Cancel"], action: { buttonIndex in
                //WeakReturn(target)
                if buttonIndex == 0 {
                    self.selectedMedia?.stopFetchingFileData(completion: { error in
                        self.statusAlertView = nil
                    })
                }
            })
        }
        selectedMedia?.fetchData(withOffset: UInt(previousOffset), update: DispatchQueue.main, update: { data, isComplete, error in
            //WeakReturn(target)
            if let error = error {
                self.statusAlertView?.updateMessage("Download Media Failed:\(error)")
                self.perform(#selector(self.dismissStatusAlertView), with: nil, afterDelay: 2.0)
            }
            if isPhoto {
                if self.fileData == nil {
                    self.fileData = data
                } else {
                    self.fileData?.append(data!)
                }
            }
            self.previousOffset += (data?.count)!
            let progress: Float = Float(self.previousOffset) * 100.0 / Float(self.selectedMedia!.fileSizeInBytes)
            self.statusAlertView?.updateMessage(String(format: "Downloading: %0.1f%%", progress))
            print("Will have to Comment Back this if")
//            if (self.previousOffset == self.selectedMedia?.fileSizeInBytes) && isComplete {
//                self.dismissStatusAlertView()
//                if isPhoto {
//                    self.showPhoto(with: self.fileData)
//                    self.savePhoto(with: self.fileData)
//                }
//            }
        })

    }

    @IBAction func playBtnAction(_ sender: Any) {
        displayImageView.isHidden = true
        if (selectedMedia?.mediaType == DJIMediaType.MOV) || (selectedMedia?.mediaType == DJIMediaType.MP4) {
            positionTextField.placeholder = "\(Int(selectedMedia?.durationInSeconds ?? 0)) sec"
            mediaManager?.playVideo(selectedMedia!, withCompletion: { error in
                if let error = error {
                    print("Play Video Failed: %@", error.localizedDescription)
                }
            })
        }
    }

    @IBAction func resumeBtnAction(_ sender: Any) {
        mediaManager?.resume(completion: { error in
            if let error = error {
                print("Resume failed: %@", error.localizedDescription)
            }
        })
    }

    @IBAction func pauseBtnAction(_ sender: Any) {
        mediaManager?.pause(completion: { error in
               if let error = error {
                print("Pause failed: %@", error.localizedDescription)
               }
           })
    }

    @IBAction func stopBtnAction(_ sender: Any) {
        mediaManager?.stop(completion: { error in
            if let error = error {
                print("Stop failed: %@", error.localizedDescription)
            }
        })
    }

    @IBAction func move(toPositionAction sender: Any) {
        var second = 0
        if positionTextField.text!.count > 0 {
             second = Int(positionTextField.text!)!
        }
       

        //WeakRef(target)
        mediaManager?.move(toPosition: Float(second), withCompletion: { error in
           // WeakReturn(target)
            if let error = error {
                print("Move to position failed: %@", error.localizedDescription)
            }
            self.positionTextField.text = ""
        })

    }

    @IBAction func showStatusBtnAction(_ sender: Any) {
        //statusView.hidden = false
        //statusView.show()
    }
    
    
    func manager(_ manager: DJIMediaManager, didUpdate state: DJIMediaVideoPlaybackState) {
        var stateStr = ""
        if state.playingMedia == nil {
            stateStr += "No media\n"
        } else {
            state.playingMedia.fileName
             let fileName = state.playingMedia.fileName
            if fileName != nil{
                stateStr += "media: \(fileName)\n"
            }
            let durationInSeconds = state.playingMedia.durationInSeconds
            if durationInSeconds != nil{
                stateStr += "Total: \(durationInSeconds)\n"
            }
            stateStr += "Orientation: \(orientation(toString: state.playingMedia.videoOrientation))\n"
        }
        stateStr += "Status: \(status(toString: state.playbackStatus))\n"
         let playingPosition = state.playingPosition
        if playingPosition != nil{
            stateStr += "Position: \(playingPosition)\n"
        }
        print("Will have to Remove this comment")
        //statusView.writeStatus(stateStr)
        print("Status of playing is updating")
    }
    func status(toString status: DJIMediaVideoPlaybackStatus) -> String? {
        switch status {
        case DJIMediaVideoPlaybackStatus.paused:
                return "Paused"
        case DJIMediaVideoPlaybackStatus.playing:
                return "Playing"
        case DJIMediaVideoPlaybackStatus.stopped:
                return "Stopped"
            default:
                break
        }
        return nil
    }
    
    //  Converted to Swift 5.2 by Swiftify v5.2.23024 - https://swiftify.com/
    func orientation(toString orientation: DJICameraOrientation) -> String? {
        switch orientation {
        case DJICameraOrientation.landscape:
                return "Landscape"
        case DJICameraOrientation.portrait:
                return "Portrait"
            default:
                break
        }
        return nil
    }
    
    
    @objc func dismissStatusAlertView() {
        statusAlertView?.dismissAlertView()
        statusAlertView = nil
    }
    
    

}
extension MediaManagerViewController{
    func showPhoto(with data: Data?) {
        if let data = data {
            let image = UIImage(data: data)
            if let image = image {
                displayImageView.image = image
                displayImageView.isHidden = false
            }
        }
    }
    
    func savePhoto(with data: Data?) {
        if let data = data {
            let image = UIImage(data: data)
            if let image = image {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    @objc func image(_ image: UIImage?, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer?) {

        var message = ""
        if let error = error {
            //Show message when save image failed
            message = "Save Image Failed! Error: \(error)"
        } else {
            //Show message when save image successfully
            message = "Saved to Photo Album"
        }

       // WeakRef(target)
        if statusAlertView == nil {
            statusAlertView = DJIAlertView.show(withMessage: message, titles: ["Dismiss"], action: { buttonIndex in
                //WeakReturn(target)
                if buttonIndex == 0 {
                    self.dismissStatusAlertView()
                }
            })
        }
    }
    func loadMediaList() {
        loadingIndicator.isHidden = false
        if mediaManager?.sdCardFileListState == DJIMediaFileListState.syncing || mediaManager?.sdCardFileListState == DJIMediaFileListState.deleting{
            print("Media Manager is busy. ")
        } else {
            //WeakRef(target)
            mediaManager?.refreshFileList(of: DJICameraStorageLocation.sdCard, withCompletion: { error in
               // WeakReturn(target)
                if let error = error {
                    print("Fetch Media File List Failed: %@", error.localizedDescription)
                } else {
                    print("Fetch Media File List Success.")
                    
                    let mediaFileList = self.mediaManager?.sdCardFileListSnapshot()
                    self.updateMediaList(mediaFileList)
                }
                self.loadingIndicator.isHidden = true
            })
        }
    }
    
    func updateMediaList(_ mediaList: [AnyHashable]?) {
        self.mediaList?.removeAll()
        if let mediaList = mediaList {
            self.mediaList?.append(contentsOf: mediaList)
        }

        let taskScheduler = DemoUtility.fetchCamera()?.mediaManager?.taskScheduler
        taskScheduler?.suspendAfterSingleFetchTaskFailure = false
        taskScheduler?.resume(completion: nil)
        for file in self.mediaList ?? [] {
            guard let file = file as? DJIMediaFile else {
                continue
            }
            if file.thumbnail == nil {
               // WeakRef(target)
                let task = DJIFetchMediaTask(file: file, content: DJIFetchMediaTaskContent.thumbnail, andCompletion: { file, content, error in
                    //WeakReturn(target)
                    self.mediaTableView.reloadData()
                })
                taskScheduler?.moveTask(toEnd: task)
            }
        }

        reloadBtn.isEnabled = true
        editBtn.isEnabled = true
    }
}
extension MediaManagerViewController: UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "mediaFileCell")
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "mediaFileCell")
            }

            if selectedCellIndexPath == indexPath {
                cell?.accessoryType = .checkmark
            } else {
                cell?.accessoryType = .none
            }

        let media = mediaList?[indexPath.row] as? DJIMediaFile
        cell?.textLabel?.text = media?.fileName
        if let timeCreated = media?.timeCreated, let durationInSeconds = media?.durationInSeconds, let customInformation = media?.customInformation {
            cell?.detailTextLabel?.text = String(format: "Create Date: %@ Size: %0.1fMB Duration:%f cusotmInfo:%@", timeCreated, Double((media?.fileSizeInBytes ?? Int64(0.0))) / 1024.0 / 1024.0, durationInSeconds, customInformation)
        }
        if media?.thumbnail == nil {
            cell?.imageView?.image = UIImage(named: "dji.png")
        } else {
            cell?.imageView?.image = media?.thumbnail
        }

        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mediaTableView.isEditing {
            return
        }

        selectedCellIndexPath = indexPath

        let currentMedia = mediaList?[indexPath.row] as? DJIMediaFile
        if !(currentMedia == selectedMedia) {
            previousOffset = 0
            selectedMedia = currentMedia
            fileData = nil
        }

        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let currentMedia = mediaList?[indexPath.row] as! DJIMediaFile
        mediaManager?.delete([currentMedia], withCompletion: { failedFiles, error in
            if let error = error {
               print("Delete File Failed:%@", error)
                for media in failedFiles {
                    print("\(media.fileName) delete failed")
                }
            } else {
                print("Delete File Successfully")
                self.mediaList?.remove(at: indexPath.row)
                self.mediaTableView.deleteRows(at: [indexPath], with: .left)
            }

        })
    }
}
