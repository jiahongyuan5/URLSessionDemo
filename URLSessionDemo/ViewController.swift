//
//  ViewController.swift
//  URLSessionDemo
//
//  Created by 贾宏远 on 2017/2/9.
//  Copyright © 2017年 xinguangnet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func handleGETRequestButtonAction(_ sender: UIButton) {
        let session = URLSession.shared
        guard let url =  URL(string: "http://rap.taobao.org/mockjsdata/13552/provincelist") else {
            return
        }
        let urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let resultData = data else {
                return
            }
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: resultData, options: .mutableLeaves)
                print(jsonObject)
            } catch {
                print("解析错误！")
            }
            
        }
        task.resume()
        
    }
    
    @IBAction func handlePOSTButtonAction(_ sender: UIButton) {
        let session = URLSession.shared
        guard let url =  URL(string: "http://app.vlychina.com/capi/vly/user/getUserInfo") else {
            return
        }
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        urlRequest.httpMethod = "POST"
        let parameters = ["token":"51EF5B24D260C11E71A663BD99C4761D8E3650A2E98D1DC7ABA5C8B99A7565A6B328FA860AAEFE8283602844847C144B3E0E6F6E62BE7F705A0870847B17341DDEA2CBF901BF75E5F8190D098778BFF06B031D1B462EF2D191ABC10821134D7C1767E6D51E8363A910A24E44C3BD953F867B1FD5F63D3E659AA2C34F6C680E199E87D4E8506FB388BFF6745109441F87C829FAF81C23A9A27A696FDD1F62A726"]
        guard let parData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
            return
        }
        urlRequest.httpBody = parData
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let resultData = data else {
                return
            }
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: resultData, options: .mutableLeaves)
                guard let dic = jsonObject as? [String: Any] else {
                    return
                }
                guard let data = dic["data"] as? [String: Any] else {
                    return
                }
                print(data["gender"] ?? "")
            } catch {
                print("解析错误！")
            }
            
        }
        task.resume()
    }
    
    @IBAction func handleUploadButtonAction(_ sender: UIButton) {
        let boundary = "Ju5tH77P15Aw350m3"
        let crlf = "\r\n"
        let initial = "--\(boundary)\(crlf)"
        let final = "\(crlf)--\(boundary)--\(crlf)"
        let contentDisposition = "Content-Disposition: form-data; name=\"image\";filename=\"image5.png\"\(crlf)"
        let mimeType = "Content-Type=image/png\(crlf)"
        var bodyData = Data()
        guard let initialData = initial.data(using: .utf8) else {
            return
        }
        guard let finalData = final.data(using: .utf8) else {
            return
        }
        guard let contentDispositionData = contentDisposition.data(using: .utf8) else {
            return
        }
        guard let mimeTypeData = mimeType.data(using: .utf8) else {
            return
        }
        
        bodyData.append(initialData)
        bodyData.append(contentDispositionData)
        bodyData.append(mimeTypeData)
        guard let imageData = UIImageJPEGRepresentation(#imageLiteral(resourceName: "Image"), 0.5) else {
            return
        }
        bodyData.append(imageData)
        bodyData.append(finalData)
        
        let sessionConfigure = URLSessionConfiguration.ephemeral
        sessionConfigure.httpAdditionalHeaders = ["Content-Type": "multipart/form-data; boundary=\(boundary)"]
        sessionConfigure.timeoutIntervalForRequest = 30
        sessionConfigure.requestCachePolicy = .reloadIgnoringLocalCacheData
        let session = URLSession(configuration: sessionConfigure)
        guard let url = URL(string: "http://picupload.service.weibo.com/interface/pic_upload.php") else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let task = session.uploadTask(with: urlRequest, from: bodyData) { (data, response, error) in
            guard let data = data else {
                return
            }
            let htmlString = String.init(data: data, encoding: .utf8)
            print(htmlString ?? "html")
            print(response ?? "response")
        }
        task.resume()
    }
    
    @IBAction func handleDownloadButtonAction(_ sender: UIButton) {
        guard let url = URL(string: "http://172.16.2.254/php/phonelogin/image.png") else {
            return
        }
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url) { (temURL, response, error) in
            let persistentPath = NSTemporaryDirectory().appending("/\(response?.suggestedFilename ?? "image.png")")
            guard let temURL = temURL else {
                print("源URL不存在")
                return
            }
            guard let persistentURL = URL(string: persistentPath) else {
                print("目标路径不存在")
                return
            }
            do {
                try FileManager.default.moveItem(at: temURL, to: persistentURL)
            } catch {
                print("移动失败")
            }
            
        }
        downloadTask.resume()
    }
    
}



