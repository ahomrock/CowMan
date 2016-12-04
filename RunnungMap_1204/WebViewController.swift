//
//  WebViewController.swift
//  RunningMap_LevelMap
//
//  Created by 陳育賢 on 2016/11/29.
//  Copyright © 2016年 aHom. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UITextFieldDelegate, UIWebViewDelegate {
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!

    @IBOutlet weak var theWebView: UIWebView!
    
    let webstring = "webtoappaction://"
    let runningweb = "http://runningmap.weebly.com/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        begin()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //The web start
    func begin() {
        
        theWebView.loadRequest(URLRequest(url: URL(string: runningweb)!))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return false
    }
    // MARK: UIWebViewDelegate Support
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let urlString:String = (request.url?.absoluteString)!
        print(urlString)
        
        
        
        if urlString.hasPrefix(webstring) {
            let parameter = urlString.replacingOccurrences(of: webstring, with: "")
            
            let alert = UIAlertController(title: "Got WebView Action", message: parameter, preferredStyle: UIAlertControllerStyle.alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(ok)
            
            present(alert, animated: true, completion: nil)
            
            return false
            
        }
        
//        if navigationType == UIWebViewNavigationType.linkClicked || navigationType == UIWebViewNavigationType.backForward {
//            urlTextField.text = urlString
//        }
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loadingIndicatorView.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadingIndicatorView.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        loadingIndicatorView.stopAnimating()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
